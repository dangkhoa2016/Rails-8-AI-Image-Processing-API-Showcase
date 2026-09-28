# Rails 8 AI Image Processing API — Visual Showcase

<p align="center">
  <a href="https://github.com/dangkhoa2016/Rails-8-AI-Image-Processing-API-Showcase/releases"><img alt="Release" src="https://img.shields.io/github/v/release/dangkhoa2016/Rails-8-AI-Image-Processing-API-Showcase?sort=semver"></a>
  <a href="./LICENSE"><img alt="License" src="https://img.shields.io/github/license/dangkhoa2016/Rails-8-AI-Image-Processing-API-Showcase"></a>
  <img alt="Rails 8 API" src="https://img.shields.io/badge/API-Rails%208-CC0000?logo=rubyonrails&logoColor=white">
  <img alt="Static showcase" src="https://img.shields.io/badge/showcase-static-2ea44f">
  <img alt="Tài liệu song ngữ" src="https://img.shields.io/badge/docs-English%20%7C%20Ti%E1%BA%BFng%20Vi%E1%BB%87t-blue">
</p>

> Ngôn ngữ: [English](README.md) | **Tiếng Việt**

Đây là showcase trực quan, tĩnh và song ngữ dành cho
[Rails-8-AI-Image-Processing-API](https://github.com/dangkhoa2016/Rails-8-AI-Image-Processing-API).

Repository này trình bày **các output thật từ API** theo cách dễ xem: xóa nền bằng
BiRefNet, segmentation theo prompt bằng MobileSAM và xử lý ảnh xác định bằng
libvips. Đây là minh họa trực quan cho hành vi của API, **không phải benchmark đánh
giá chất lượng model** và cũng không phải Rails API server.

## Showcase có gì?

Nội dung hiện có gồm:

- so sánh before/after cho xóa nền;
- cutout PNG nền trong suốt và ảnh ghép trên nền trung tính;
- ví dụ BiRefNet với người và nhiều dạng vật thể;
- MobileSAM với point prompt và box prompt;
- ví dụ lựa chọn người, chó, mèo và ngựa;
- các ví dụ resize, crop, contrast, saturation, tint, sharpen và WebP có kết quả xác định;
- code snippet dùng placeholder cho deployment URL và authentication token;
- giao diện tiếng Anh và tiếng Việt;
- provenance của ảnh nguồn và metadata integrity SHA-256.

Trang public nằm trong thư mục <code>site/</code>.

## Bộ ba repository của dự án

| Repository | Vai trò |
| --- | --- |
| [Rails-8-AI-Image-Processing-API](https://github.com/dangkhoa2016/Rails-8-AI-Image-Processing-API) | Source ứng dụng Rails 8, authentication, API endpoint và phần tích hợp AI/xử lý ảnh |
| **Repository này** | Trình bày trực quan, dễ hiểu bằng các response thật từ API |
| [Community Acceptance Kit](https://github.com/dangkhoa2016/Rails-8-AI-Image-Processing-API-Community-Acceptance-Kit) | Kiểm thử black-box có thể tái lập, báo cáo, evidence và kiểm tra integrity |

Việc tách riêng ba vai trò giúp dự án dễ hiểu hơn: implementation ở API repository,
minh họa trực quan ở đây và xác minh kỹ thuật công khai ở acceptance kit.

## Mục tiêu deployment

Showcase này được thiết kế để publish dưới dạng **HTML tĩnh**. Kiến trúc hosting
public đã thống nhất là:

- **Cloudflare Pages** — static deployment chính từ nội dung trong <code>site/</code>.
- **Hugging Face Spaces (Static HTML)** — static mirror của cùng showcase đã được review.
- **GitHub Pages** — **không phải deployment target đang sử dụng cho project này**.

GitHub Pages đã từng được thử trước đó, nhưng bị xung đột với custom-domain routing
đã có sẵn trên account. Branch dùng cho Pages đã được xóa và project chuyển sang
Cloudflare Pages cùng một Hugging Face Static HTML mirror.

README sẽ chỉ ghi public URL cố định của Cloudflare Pages/Hugging Face sau khi các
deployment đó thực sự được tạo và verify.

## Cấu trúc repository

| Đường dẫn | Nội dung |
| --- | --- |
| <code>site/index.html</code> | Giao diện showcase tĩnh, song ngữ |
| <code>site/assets/</code> | Các public asset được trang showcase sử dụng |
| <code>site/SHA256SUMS</code> | Manifest SHA-256 của public site assets |
| <code>assets/input/</code> | Ảnh nguồn và các bản runtime-sized |
| <code>assets/output/</code> | Output từ API hoặc từ bước post-processing xác định |
| <code>assets/provenance.json</code> | URL nguồn, license, mô tả và hash binding của các input đã được ghi nhận |
| <code>scripts/setup_runtime_env.sh</code> | Helper tương tác để tạo file credential runtime tạm một cách an toàn |
| <code>scripts/run_people_animals.sh</code> | Tạo lại một nhóm ví dụ people/animals và cài chúng vào site |
| <code>.env.example</code> | File tham khảo chỉ chứa placeholder cho các biến môi trường runtime |

## Quick start: xem showcase trên máy local

Chỉ để xem showcase thì **không cần** Rails app, GPU, BiRefNet, MobileSAM hay model
runtime.

Yêu cầu:

- Git
- Python 3, chỉ để serve static files

Clone repository và chạy static server:

~~~bash
git clone https://github.com/dangkhoa2016/Rails-8-AI-Image-Processing-API-Showcase.git
cd Rails-8-AI-Image-Processing-API-Showcase/site
python3 -m http.server 8080
~~~

Sau đó mở:

~~~text
http://127.0.0.1:8080
~~~

Nếu hệ thống chỉ có lệnh <code>python</code> thay vì <code>python3</code>, có thể
dùng <code>python</code>.

## Tạo lại một số output từ API

Phần này là tùy chọn. Chỉ cần thực hiện khi muốn tái tạo nhóm asset
people/animals từ một API deployment đang chạy.

### Yêu cầu

Cần có:

- một deployment đang truy cập được của Rails-8-AI-Image-Processing-API;
- một test account hợp lệ trên deployment đó;
- Ruby với standard library mà các script đang sử dụng;
- Python 3;
- Pillow cho bước tạo selection preview ở local.

AI inference được thực hiện ở API deployment. Máy chạy helper của showcase không
cần GPU riêng nếu remote deployment đã cung cấp AI runtime cần thiết.

### Các biến môi trường runtime

Script sử dụng đúng ba biến sau:

| Biến | Ý nghĩa |
| --- | --- |
| <code>BASE_URL</code> | Base URL của Rails API deployment đang chạy; không bắt buộc phải có dấu / cuối |
| <code>E2E_EMAIL</code> | Email của test account |
| <code>E2E_PASSWORD</code> | Password của test account |

[.env.example](./.env.example) mô tả schema bằng placeholder, không chứa credential
thật.

### Cách setup credential được khuyến nghị

Chạy helper tương tác:

~~~bash
./scripts/setup_runtime_env.sh
~~~

Script sẽ hỏi deployment URL, test email và password, rồi tạo file credential có
shell escaping tại:

~~~text
/tmp/showcase-e2e.env
~~~

File được tạo với mode <code>600</code>; password được nhập ở chế độ không hiển thị.

Sau đó chạy:

~~~bash
./scripts/run_people_animals.sh
~~~

Khi hoàn tất:

~~~bash
rm -f /tmp/showcase-e2e.env
~~~

### Dùng .env.example thủ công

File example được thiết kế để có thể commit an toàn và chỉ chứa placeholder.

~~~bash
cp .env.example /tmp/showcase-e2e.env
chmod 600 /tmp/showcase-e2e.env
vi /tmp/showcase-e2e.env
SHOWCASE_ENV_FILE=/tmp/showcase-e2e.env ./scripts/run_people_animals.sh
rm -f /tmp/showcase-e2e.env
~~~

Nếu sửa file thủ công, cần giữ cú pháp shell hợp lệ. Với password có ký tự đặc biệt
của shell, helper tương tác an toàn hơn vì nó tự ghi giá trị đã được shell-escape.

## Helper regeneration thực sự làm gì?

Workflow people/animals hiện tại được giới hạn có chủ đích. Nó **không** tạo lại
toàn bộ mọi visual trên trang.

Runner sẽ:

1. gọi <code>POST /users/sign_in</code> và lấy JWT từ flow đăng nhập bình thường;
2. gọi <code>POST /images/remove-background</code> để tạo output người với nền trong suốt và nền trung tính;
3. gọi <code>POST /images/segment</code> để tạo point/box mask cho người, chó và ngựa;
4. dùng Pillow ở local để tạo selection-preview WebP cho chó/ngựa từ mask;
5. copy các asset đã chọn vào <code>site/assets/</code>;
6. cập nhật lại <code>site/SHA256SUMS</code>.

Trang tĩnh còn chứa các ví dụ curated khác, bao gồm xóa nền vật thể và các phép
biến đổi ảnh xác định. Những phần đó được quản lý riêng, không nằm trong helper
people/animals này.

## Các API endpoint mà helper sử dụng

| Endpoint | Mục đích |
| --- | --- |
| <code>POST /users/sign_in</code> | Đăng nhập test account và nhận JWT |
| <code>POST /images/remove-background</code> | Tạo output xóa nền bằng BiRefNet |
| <code>POST /images/segment</code> | Tạo segmentation mask point/box bằng MobileSAM |

Bản thân trang showcase cũng có các ví dụ curl có thể copy, nhưng chỉ dùng
placeholder thay vì nhúng credential của deployment.

## Provenance và integrity

Provenance của ảnh nguồn được ghi trong
[assets/provenance.json](./assets/provenance.json). Các ảnh lấy từ nguồn public vẫn
giữ thông tin license/provenance của chính chúng; ví dụ CC0 vẫn được ghi nhận là
CC0 chứ không bị relicensing bởi repository này.

Manifest của public site là [site/SHA256SUMS](./site/SHA256SUMS). Từ thư mục
<code>site/</code>, có thể kiểm tra asset đã publish bằng:

~~~bash
sha256sum -c SHA256SUMS
~~~

Manifest giúp phát hiện asset bị thay đổi ngoài ý muốn và ràng buộc trang showcase
với đúng các file đã được review.

## Quy tắc bảo mật

Không commit hoặc publish:

- password thật của deployment;
- JWT hoặc refresh token;
- cookie hoặc session material;
- SMTP/API credential;
- GitHub token;
- cấu hình deployment riêng tư.

Repository ignore các file <code>.env</code>/<code>.env.*</code> local nhưng cho
phép riêng <code>.env.example</code> chỉ chứa placeholder.

Để tái lập một run, nên dùng credential file ngắn hạn trong <code>/tmp</code>, đặt
mode <code>600</code> và xóa ngay sau khi hoàn thành.

## Cập nhật showcase an toàn

Một thay đổi nội dung điển hình nên theo thứ tự:

1. chọn source asset có provenance và điều kiện redistribution rõ ràng;
2. ghi hoặc cập nhật metadata nguồn trong <code>assets/provenance.json</code>;
3. nếu ví dụ đại diện cho API response thì tạo output thông qua API thật;
4. review trực quan kết quả;
5. đưa asset đã duyệt vào <code>site/assets/</code>;
6. cập nhật <code>site/SHA256SUMS</code>;
7. preview <code>site/</code> ở local và kiểm tra toàn bộ asset được tham chiếu;
8. giữ nội dung public EN/VI đồng bộ;
9. không mô tả các visual example như benchmark chất lượng model.

## Release và main

Public release đầu tiên là
[v1.0.0](https://github.com/dangkhoa2016/Rails-8-AI-Image-Processing-API-Showcase/releases/tag/v1.0.0).

Tag release là snapshot lịch sử. Nhánh <code>main</code> có thể nhận thêm cải tiến
visual hoặc tài liệu sau release, trong khi tag release hiện có vẫn được giữ nguyên.

## License

Code và tài liệu của repository dùng
[MIT License](./LICENSE).

Các asset bên thứ ba, public-domain và CC0 giữ provenance và điều kiện license riêng
như được ghi trong [assets/provenance.json](./assets/provenance.json).
