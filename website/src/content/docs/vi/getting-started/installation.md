---
title: Cài đặt
description: Cài Texchanges trên máy hoặc dùng trực tiếp trên Overleaf.
---

## Bản phân phối TeX

Texchanges được phân phối qua TeX Live. Cài bằng trình quản lý gói của bản phân phối khi cần, rồi nạp gói như bình thường:

```latex
\usepackage[review]{texchanges}
```

Việc gói có mặt trên CTAN và phiên bản TeX Live mà một dự án đang chọn là hai chuyện khác nhau. Hãy tải `texchanges.sty` lên khi phiên bản TeX Live đang dùng chưa có gói này.

## Phương án dự phòng cho Overleaf

Tải `texchanges-overleaf.zip` từ bản phát hành GitHub mới nhất và tải lên thành một dự án. Gói này gồm `texchanges.sty` làm bản dự phòng, `texchanges-explicit-review.tex`, hai bản sửa cho phần so sánh tự động, `texchanges-review.tex`, và `latexmkrc`. Giữ nguyên dòng nạp gói.

## Cài thủ công

Đặt `texchanges.sty` vào thư mục tài liệu hoặc vào cây `texmf` cục bộ, sau đó cập nhật lại cơ sở dữ liệu tên tệp nếu bản phân phối của bạn yêu cầu.
