using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SystemFoodOrder.Data;
using static SystemFoodOrder.Model.DTOs.UserProfileDTOs;

namespace SystemFoodOrder.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserProfileController : ControllerBase
    {
        private readonly AppDbContext _context;

        public UserProfileController(AppDbContext context)
        {
            _context = context;
        }

        // GET: api/User/5
        [HttpGet("{id}")]
        public async Task<IActionResult> GetProfile(int id)
        {
            var user = await _context.Users.FindAsync(id);

            if (user == null)
            {
                return NotFound(new { success = false, message = "User not found." });
            }

            // Map the database entity to our safe DTO
            var profileDto = new UserProfileResponse
            {
                UserId = user.UserId,
                Username = user.Username,
                FullName = user.FullName,
                Phone = user.Phone,
                Email = user.Email,
                Address = user.Address
            };

            return Ok(new { success = true, user = profileDto });
        }

        // PUT: api/User/5
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateProfile(int id, [FromBody] UpdateProfileRequest request)
        {
            var user = await _context.Users.FindAsync(id);

            if (user == null)
            {
                return NotFound(new { success = false, message = "User not found." });
            }

            // Update the user's properties
            user.FullName = request.FullName;
            user.Phone = request.Phone;
            user.Email = request.Email;
            user.Address = request.Address;

            try
            {
                // Save changes to the SQL Database
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateException)
            {
                return StatusCode(500, new { success = false, message = "An error occurred while updating the profile." });
            }

            // Return the updated profile
            var updatedProfile = new UserProfileResponse
            {
                UserId = user.UserId,
                Username = user.Username, // Kept the original username
                FullName = user.FullName,
                Phone = user.Phone,
                Email = user.Email,
                Address = user.Address
            };

            return Ok(new { success = true, message = "Profile updated successfully!", user = updatedProfile });
        }
    }
}
