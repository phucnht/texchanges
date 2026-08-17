---
title: Bắt đầu nhanh
description: Thêm đánh dấu review và chọn chế độ tài liệu.
---

```latex
\documentclass{article}
\usepackage[review]{texchanges}

\begin{document}
This \txreplace{draft}{revised} sentence contains a replacement.
This paragraph has \txadd{new text} and \txremove{old text}.
\end{document}
```

Biên dịch ở chế độ `review` để hiển thị phần đánh dấu. Đổi tùy chọn sang `final` để dựng ra văn bản được đề xuất, hoặc `original` để dựng lại tài liệu ban đầu.

Lệnh thay thế trong API gốc luôn theo thứ tự `\txreplace{cũ}{mới}`.
