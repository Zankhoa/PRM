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

            if (!string.IsNullOrWhiteSpace(request.Email))
            {
                var emailExists = await _context.Users.AnyAsync(u => u.Email == request.Email);
                if (emailExists)
                {
                    return BadRequest(new { success = false, message = "Email already exists." });
                }
            }

            // Resolve the default end-user role dynamically instead of assuming roleId = 3.
            var userRoleId = await _context.Roles
                .Where(r => r.RoleName == "User" || r.RoleName == "Customer")
                .Select(r => (int?)r.RoleId)
                .FirstOrDefaultAsync();

            if (!userRoleId.HasValue)
            {
                var createdRole = new Role { RoleName = "User" };
                _context.Roles.Add(createdRole);
                await _context.SaveChangesAsync();
                userRoleId = createdRole.RoleId;
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
                RoleId = userRoleId
            };

            // 3. Save to database
            try
            {
                _context.Users.Add(newUser);
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateException ex)
            {
                return StatusCode(500, new
                {
                    success = false,
                    message = $"Could not create user: {ex.InnerException?.Message ?? ex.Message}"
                });
            }

            // Returns HTTP 200 to Flutter
            return Ok(new { success = true, message = "Registration successful!", userId = newUser.UserId });
        }

        // POST: api/Auth/login
        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] Model.DTOs.LoginRequest request)
        {
            // 1. Find user by matching BOTH plain text username and password
            var user = await _context.Users
                .Include(u => u.Role)
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
                    RoleName = user.Role != null ? user.Role.RoleName : null,
                    user.AvatarUser
                }
            });
        }
    }
}
