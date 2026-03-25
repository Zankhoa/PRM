using Microsoft.AspNetCore.Mvc;
using System.Net;
using System.Net.Http.Headers;

namespace SystemFoodOrder.Controllers;

[ApiController]
[Route("api/images")]
public class ImagesController : ControllerBase
{
    private static readonly HttpClient _http = new HttpClient();

    static ImagesController()
    {
        // Unsplash có thể phản hồi khác nhau nếu request không có header User-Agent.
        _http.DefaultRequestHeaders.UserAgent.ParseAdd("Mozilla/5.0 (compatible; FoodOrderApp/1.0)");
    }

    [HttpGet("proxy")]
    public async Task<IActionResult> Proxy([FromQuery] string url, CancellationToken ct)
    {
        if (string.IsNullOrWhiteSpace(url))
            return BadRequest(new { message = "Missing 'url' query parameter." });

        // Một số lần người dùng copy/link tool có thể kèm dấu '<' '>' => làm URL invalid.
        var cleaned = url.Trim().Trim('<', '>');
        if (!Uri.TryCreate(cleaned, UriKind.Absolute, out var uri))
            return BadRequest(new { message = "Invalid image url." });

        if (uri.Scheme != Uri.UriSchemeHttps && uri.Scheme != Uri.UriSchemeHttp)
            return BadRequest(new { message = "Only http/https images are allowed." });

        // Basic SSRF guard (demo-level): block localhost/loopback.
        if (IPAddress.TryParse(uri.Host, out var ip))
        {
            if (IPAddress.IsLoopback(ip) || ip.Equals(IPAddress.Any) || ip.Equals(IPAddress.IPv6Any))
                return BadRequest(new { message = "Host not allowed." });
        }
        else
        {
            var hostLower = uri.Host.ToLowerInvariant();
            if (hostLower is "localhost" or "127.0.0.1" or "::1")
                return BadRequest(new { message = "Host not allowed." });
        }

        try
        {
            using var resp = await _http.GetAsync(uri, HttpCompletionOption.ResponseHeadersRead, ct);
            if (!resp.IsSuccessStatusCode)
            {
                return StatusCode((int)resp.StatusCode, new { message = "Proxy upstream failed." });
            }

            var contentType = resp.Content.Headers.ContentType?.MediaType;
            if (string.IsNullOrWhiteSpace(contentType))
                contentType = "application/octet-stream";

            // Cache slightly to reduce repeated proxying.
            Response.Headers.CacheControl = "public, max-age=3600";
            // CORS cho request ảnh từ Flutter web (khác port vẫn là cross-origin).
            Response.Headers["Access-Control-Allow-Origin"] = "*";

            // Đọc full bytes để tránh lỗi stream khi `resp` bị dispose.
            var bytes = await resp.Content.ReadAsByteArrayAsync(ct);
            return File(bytes, contentType);
        }
        catch (Exception ex)
        {
            return StatusCode(500, new { message = "Proxy error", detail = ex.Message });
        }
    }
}

