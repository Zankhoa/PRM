using System;
using System.Collections.Generic;

namespace SystemFoodOrder.Model.DTOs
{
    public class BlogDto
    {
        public int BlogId { get; set; }
        public int? UserId { get; set; }
        public string Title { get; set; } = string.Empty;
        public string Content { get; set; } = string.Empty;
        public DateTime? CreatedAt { get; set; }
    }

    public class CreateBlogDto
    {
        public int? UserId { get; set; }
        public string Title { get; set; } = string.Empty;
        public string Content { get; set; } = string.Empty;
    }
}
