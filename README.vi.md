# Rails 8 AI Image Processing API — Visual Showcase

Đây là showcase trực quan, tĩnh và song ngữ cho dự án
[Rails-8-AI-Image-Processing-API](https://github.com/dangkhoa2016/Rails-8-AI-Image-Processing-API).

Trang trình bày các kết quả thật được tạo từ API, bao gồm xóa nền bằng BiRefNet,
phân đoạn theo prompt bằng MobileSAM và xử lý ảnh xác định bằng libvips. Đây là
minh họa trực quan, không phải benchmark đánh giá chất lượng model.

## Repository này dùng để làm gì?

Repository này trả lời câu hỏi đơn giản: **API có thể làm được gì?**

Nội dung gồm:

- ví dụ before/after cho xóa nền;
- PNG nền trong suốt và ảnh ghép trên nền trung tính;
- ví dụ MobileSAM với point prompt và box prompt;
- ví dụ phân đoạn người, chó, mèo và ngựa;
- ví dụ xử lý resize, contrast, saturation, tint và sharpen;
- các lệnh curl có thể tái lập hiển thị trực tiếp trên trang;
- giao diện tiếng Anh và tiếng Việt;
- metadata SHA-256 cho các asset public.

Để xem kiểm thử API black-box, báo cáo có thể tái lập và bằng chứng kiểm tra
tính toàn vẹn, hãy xem
[repository xác minh công khai](https://github.com/dangkhoa2016/Rails-8-AI-Image-Processing-API-Community-Acceptance-Kit).

## Xem thử trên máy local

Không cần Rails server, GPU hay model runtime để xem showcase.

    cd site
    python3 -m http.server 8080

Sau đó mở http://127.0.0.1:8080.

## Tái tạo output từ API

Các script trong scripts/ là công cụ tùy chọn để tạo lại một số output từ
một deployment đang hoạt động.

Credential runtime được cố ý không lưu trong repository.

    ./scripts/setup_runtime_env.sh
    ./scripts/run_people_animals.sh
    rm -f /tmp/showcase-e2e.env

Các request sử dụng JWT trả về từ flow đăng nhập bình thường của deployment.
Không commit deployment URL, password, JWT, refresh token, cookie hay secret.

## Provenance và integrity

Provenance của ảnh nguồn được ghi trong assets/provenance.json.

Manifest cho public site là site/SHA256SUMS. Hai ví dụ speaker và hat hiện
dùng ảnh nguồn Wikimedia Commons theo CC0 1.0. Các nguồn và binding khác được
ghi rõ trong file provenance.

## Vai trò của các repository

- **Main API repository** — source ứng dụng và phần triển khai API.
- **Visual Showcase** — minh họa trực quan bằng output thật.
- **Public verification repository** — kiểm thử black-box có thể tái lập, báo
  cáo, evidence và hash.

Việc tách các vai trò giúp dự án dễ hiểu hơn: phần trực quan nằm ở đây, phần
triển khai nằm trong repository chính và phần xác minh kỹ thuật nằm trong
repository xác minh.

## License

Code và tài liệu của repository này sử dụng MIT License.

Các asset bên thứ ba/public-domain/CC0 giữ provenance và điều kiện license
riêng như được ghi trong assets/provenance.json.
