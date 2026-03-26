using System;
using System.Collections.Generic;

namespace SystemFoodOrder.Model.DTOs
{
    public class NotificationDto
    {
        public int NotificationId { get; set; }
        public string? Title { get; set; }
        public string? Message { get; set; }
        public bool IsRead { get; set; }
        public DateTime? CreatedAt { get; set; }
    }

    public class CreateNotificationDto
    {
        public int? UserId { get; set; }
        public string Title { get; set; } = string.Empty;
        public string Message { get; set; } = string.Empty;
    }
}
