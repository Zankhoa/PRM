using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity.Data;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SystemFoodOrder.Data;
using SystemFoodOrder.Model.Entities;

namespace SystemFoodOrder.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly AppDbContext _context;

        public AuthController(AppDbContext context)
        {
            _context = context;
        }

        // POST: api/Auth/register
        [HttpPost("register")]
        public async Task<IActionResult> Register([FromBody] Model.DTOs.RegisterRequest request)
        {
            // 1. Check if the username already exists
            var userExists = await _context.Users.AnyAsync(u => u.Username == request.Username);
            if (userExists)
            {
                // Returns HTTP 400 to Flutter
                return BadRequest(new { success = false, message = "Username already exists." });
            }

            // 2. Create the new User entity mapping from the request
            var newUser = new User
            {
                Username = request.Username,
                FullName = request.FullName,
                Password = request.Password, // Storing in plain text as requested
                Phone = request.Phone,
                Email = request.Email,
                Address = request.Address,
                CreatedAt = DateTime.UtcNow,
                IsActive = true,
                RoleId = 3 // Example: Assigning a default RoleId (e.g., 2 for 'Customer')
            };

            // 3. Save to database
            _context.Users.Add(newUser);
            await _context.SaveChangesAsync();

            // Returns HTTP 200 to Flutter
            return Ok(new { success = true, message = "Registration successful!", userId = newUser.UserId });
        }

        // POST: api/Auth/login
        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] Model.DTOs.LoginRequest request)
        {
            // 1. Find user by matching BOTH plain text username and password
            var user = await _context.Users
                .FirstOrDefaultAsync(u => u.Username == request.Username && u.Password == request.Password);

            // 2. If no match found
            if (user == null)
            {
                // Returns HTTP 401 to Flutter
                return Unauthorized(new { success = false, message = "Invalid username or password." });
            }

            // 3. Check if account is active
            if (user.IsActive == false)
            {
                return Unauthorized(new { success = false, message = "Your account has been deactivated." });
            }

            // 4. Return success and basic user data (No JWT)
            return Ok(new
            {
                success = true,
                message = "Login successful",
                user = new
                {
                    user.UserId,
                    user.Username,
                    user.FullName,
                    user.Email,
                    user.Phone,
                    user.RoleId,
                    user.AvatarUser
                }
            });
        }
    }
}
