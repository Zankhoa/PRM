namespace SystemFoodOrder.Model.DTOs
{
    public class UserProfileDTOs
    {
        public class UserProfileResponse
        {
            public int UserId { get; set; }
            public string Username { get; set; } = null!;
            public string FullName { get; set; } = null!;
            public string? Phone { get; set; }
            public string? Email { get; set; }
            public string? Address { get; set; }
        }

        public class UpdateProfileRequest
        {
            public string FullName { get; set; } = null!;
            public string? Phone { get; set; }
            public string? Email { get; set; }
            public string? Address { get; set; }
        }
    }
}
