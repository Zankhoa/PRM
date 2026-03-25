using System.Text.Json;
using Microsoft.EntityFrameworkCore;
using SystemFoodOrder.Data;
using SystemFoodOrder.Infrastructure;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

builder.Services.AddScoped<SystemFoodOrder.Service.OrderService>();
builder.Services.AddScoped<SystemFoodOrder.Service.UserService>();
builder.Services.AddScoped<SystemFoodOrder.Service.ProductService>();
builder.Services.AddScoped<SystemFoodOrder.Service.CartService>();
builder.Services.AddScoped<SystemFoodOrder.Service.CheckoutService>();
builder.Services.AddScoped<SystemFoodOrder.Service.DiscountService>();
builder.Services.AddScoped<SystemFoodOrder.Service.OrderQueryService>();
builder.Services.AddScoped<SystemFoodOrder.Service.ShopOrderService>();

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

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

if (!app.Environment.IsDevelopment())
    app.UseHttpsRedirection();

app.UseCors();
app.UseAuthorization();
app.MapControllers();
app.Run();
