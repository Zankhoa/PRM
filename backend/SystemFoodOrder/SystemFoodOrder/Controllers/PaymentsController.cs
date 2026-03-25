using Microsoft.AspNetCore.Mvc;
using SystemFoodOrder.Data;
using Microsoft.EntityFrameworkCore;

namespace SystemFoodOrder.Controllers;

[ApiController]
[Route("api/users/{userId:int}/payments")]
public class PaymentsController : ControllerBase
{
    private readonly AppDbContext _db;
    public PaymentsController(AppDbContext db)
    {
        _db = db;
    }

    [HttpGet("{orderId:int}")]
    public async Task<IActionResult> GetPaymentStatus(int userId, int orderId)
    {
        var payment = await _db.Payments.AsNoTracking()
            .Where(p => p.OrderId == orderId)
            .Select(p => new { p.PaymentId, p.Status, p.PaymentMethod, p.Amount, p.CreatedAt })
            .FirstOrDefaultAsync();
        if (payment == null) return NotFound(new { message = "Payment not found." });
        return Ok(payment);
    }
}
