using Microsoft.EntityFrameworkCore;
using System.Text.Json;
using SystemFoodOrder.Data;
using SystemFoodOrder.Infrastructure;
using SystemFoodOrder.Service;

var builder = WebApplication.CreateBuilder(args);

// 1. CẤU HÌNH CORS (Bắt buộc cho Flutter Web)
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowFlutterWeb",
        policy =>
        {
            policy.AllowAnyOrigin()
                  .AllowAnyHeader()
                  .AllowAnyMethod();
        });
});

//register appdbcontext 
builder.Services.AddDbContext<AppDbContext>(options => options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));
builder.Services.AddScoped<ProductManageService>();
builder.Services.AddScoped<UserService>();
builder.Services.AddScoped<OrderService>();
builder.Services.AddScoped<SystemFoodOrder.Service.ProductService>();
builder.Services.AddScoped<SystemFoodOrder.Service.CartService>();
builder.Services.AddScoped<SystemFoodOrder.Service.CheckoutService>();
builder.Services.AddScoped<SystemFoodOrder.Service.DiscountService>();
builder.Services.AddScoped<SystemFoodOrder.Service.OrderQueryService>();
builder.Services.AddScoped<SystemFoodOrder.Service.ShopOrderService>();

// Add services to the container.
builder.Services.AddControllers().AddJsonOptions(o =>
{
    o.JsonSerializerOptions.PropertyNamingPolicy = JsonNamingPolicy.CamelCase;
    o.JsonSerializerOptions.PropertyNameCaseInsensitive = true;
});
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
    {
        policy.AllowAnyOrigin().AllowAnyHeader().AllowAnyMethod();
    });
});

var app = builder.Build();
try
{
    await using (var scope = app.Services.CreateAsyncScope())
    {
        var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();
        await DatabaseBootstrap.RunAsync(db);
    }
}
catch (Exception ex)
{
    Console.WriteLine($"[Bootstrap] {ex.Message}");
}

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseCors("AllowFlutterWeb");

app.UseAuthorization();

app.MapControllers();

app.Run();
