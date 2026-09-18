CREATE DATABASE IF NOT EXISTS webphp
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE webphp;

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    email VARCHAR(160) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(30) DEFAULT NULL,
    address VARCHAR(255) DEFAULT NULL,
    role ENUM('user', 'admin') NOT NULL DEFAULT 'user',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(120) NOT NULL UNIQUE,
    description VARCHAR(255) DEFAULT NULL,
    image VARCHAR(255) DEFAULT 'img/JTPSD2ONPYISBHIP4CJ5HDW55A_01.webp',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT NULL,
    name VARCHAR(160) NOT NULL,
    description TEXT,
    price DECIMAL(12, 2) NOT NULL DEFAULT 0,
    image VARCHAR(255) DEFAULT 'img/JTPSD2ONPYISBHIP4CJ5HDW55A_01.webp',
    status TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_products_category
        FOREIGN KEY (category_id) REFERENCES categories(id)
        ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NULL,
    customer_name VARCHAR(120) NOT NULL,
    customer_email VARCHAR(160) DEFAULT NULL,
    customer_phone VARCHAR(30) NOT NULL,
    customer_address VARCHAR(255) NOT NULL,
    total_amount DECIMAL(12, 2) NOT NULL DEFAULT 0,
    coupon_code VARCHAR(50) DEFAULT NULL,
    discount_amount DECIMAL(12, 2) NOT NULL DEFAULT 0,
    status ENUM('pending', 'confirmed', 'shipping', 'completed', 'cancelled') NOT NULL DEFAULT 'pending',
    payment_method ENUM('cod', 'bank', 'momo') NOT NULL DEFAULT 'cod',
    payment_status ENUM('pending', 'paid', 'unpaid', 'failed') NOT NULL DEFAULT 'pending',
    note TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_orders_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NULL,
    product_name VARCHAR(160) NOT NULL,
    size VARCHAR(10) NOT NULL DEFAULT 'M',
    price DECIMAL(12, 2) NOT NULL DEFAULT 0,
    quantity INT NOT NULL DEFAULT 1,
    subtotal DECIMAL(12, 2) NOT NULL DEFAULT 0,
    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id) REFERENCES orders(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_order_items_product
        FOREIGN KEY (product_id) REFERENCES products(id)
        ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS coupons (
    id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255) DEFAULT NULL,
    discount_type ENUM('fixed', 'percent') NOT NULL DEFAULT 'fixed',
    discount_value DECIMAL(12, 2) NOT NULL DEFAULT 0,
    min_order_amount DECIMAL(12, 2) NOT NULL DEFAULT 0,
    max_discount_amount DECIMAL(12, 2) DEFAULT NULL,
    usage_limit INT DEFAULT NULL,
    used_count INT NOT NULL DEFAULT 0,
    expires_at DATETIME DEFAULT NULL,
    status TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS payments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    amount DECIMAL(12, 2) NOT NULL DEFAULT 0,
    method ENUM('cod', 'bank', 'momo') NOT NULL DEFAULT 'cod',
    status ENUM('pending', 'paid', 'unpaid', 'failed') NOT NULL DEFAULT 'pending',
    transaction_code VARCHAR(80) DEFAULT NULL,
    paid_at DATETIME DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_payments_order
        FOREIGN KEY (order_id) REFERENCES orders(id)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS support_tickets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NULL,
    order_id INT NULL,
    customer_name VARCHAR(120) NOT NULL,
    customer_email VARCHAR(160) DEFAULT NULL,
    customer_phone VARCHAR(30) NOT NULL,
    subject VARCHAR(180) NOT NULL,
    message TEXT NOT NULL,
    priority ENUM('normal', 'urgent') NOT NULL DEFAULT 'normal',
    status ENUM('new', 'in_progress', 'resolved', 'closed') NOT NULL DEFAULT 'new',
    admin_reply TEXT,
    replied_at DATETIME DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_support_tickets_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE SET NULL,
    CONSTRAINT fk_support_tickets_order
        FOREIGN KEY (order_id) REFERENCES orders(id)
        ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS product_reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    user_id INT NULL,
    customer_name VARCHAR(120) NOT NULL,
    customer_email VARCHAR(160) DEFAULT NULL,
    rating TINYINT NOT NULL DEFAULT 5,
    comment TEXT NOT NULL,
    admin_reply TEXT DEFAULT NULL,
    admin_replied_at DATETIME DEFAULT NULL,
    status ENUM('approved', 'hidden') NOT NULL DEFAULT 'approved',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_reviews_product
        FOREIGN KEY (product_id) REFERENCES products(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_reviews_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO users (id, name, email, password, phone, address, role)
VALUES
    (1, 'Admin Pizza', 'admin@pizza.test', '$2y$10$kKfzP0wmSz9969LQKv8KpOlrFVEUDkIi4mkho8qwO7Dvmg7CmQZwu', '0909000000', 'Văn phòng Pizza House', 'admin'),
    (2, 'Khách Hàng Mẫu', 'user@pizza.test', '$2y$10$PW8l5M8SubFPESRHT9HtEelendHKnpHT8bL.MYKvgcx5J7WcMmHgO', '0911222333', '123 Đường Pizza, Quận 1', 'user')
ON DUPLICATE KEY UPDATE
    name = VALUES(name),
    phone = VALUES(phone),
    address = VALUES(address),
    role = VALUES(role);

INSERT INTO categories (id, name, description, image)
VALUES
    (1, 'Pizza truyền thống', 'Những hương vị kinh điển dễ ăn.', 'img/JTPSD2ONPYISBHIP4CJ5HDW55A_01.webp'),
    (2, 'Pizza hải sản', 'Tôm, mực, thanh cua và phô mai kéo sợi.', 'img/BYO_Garlic-Shrimp-Pizza-1-360x360.jpg'),
    (3, 'Pizza đặc biệt', 'Công thức đậm vị dành cho bữa tiệc.', 'img/PestoE1A3iE1A3n.webp'),
    (4, 'Gà rán giòn rụm', 'Gà rán vàng giòn, đậm đà chuẩn vị ăn kèm khoai tây.', 'img/11.jfif'),
    (5, 'Đồ uống giải khát', 'Nước ngọt có gas, sảng khoái từng ngụm mát lạnh.', 'img/pepsi.png'),
    (6, 'Mì Ý & Khai vị', 'Mì Ý sốt bò bằm phô mai béo ngậy và khoai tây chiên giòn tan.', 'img/spagetti1.jpg'),
    (7, 'Combo Khuyến mãi', 'Các gói combo tiệc gà, pizza ưu đãi siêu tiết kiệm.', 'img/khuyenmai3.jpg'),
    (8, 'Mì nước', 'Mì ramen, mì cay kim chi, mì gà tiềm và mì bò súp nóng hổi thơm ngon đậm đà.', 'img/mi_ramen_xa_xiu.jpg')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    image = VALUES(image);

INSERT INTO products (id, category_id, name, description, price, image, status)
VALUES
    (1, 1, 'Pizza Margherita', 'Sốt cà chua, mozzarella, lá basil và đế nướng giòn.', 99000, 'img/JTPSD2ONPYISBHIP4CJ5HDW55A_01.webp', 1),
    (2, 1, 'Pizza Pepperoni', 'Pepperoni cay nhẹ, phô mai mozzarella và sốt cà chua Ý.', 129000, 'img/images.jfif', 1),
    (3, 1, 'Pizza Hawaiian', 'Giăm bông, thơm, phô mai béo và sốt cà chua dịu ngọt.', 119000, 'img/images (1).jfif', 1),
    (4, 2, 'Pizza Hải Sản', 'Tôm, mực, thanh cua, hành tây và sốt thousand island.', 159000, 'img/BYO_Garlic-Shrimp-Pizza-1-360x360.jpg', 1),
    (5, 3, 'Pizza Gà BBQ', 'Gà nướng BBQ, bắp ngọt, hành tây và phô mai đậm vị.', 149000, 'img/istockphoto-1442417585-612x612.jpg', 1),
    (6, 3, 'Pizza Rau Củ', 'Ớt chuông, nấm, olive, bắp ngọt và sốt cà chua thanh nhẹ.', 109000, 'img/PestoE1A3iE1A3n.webp', 1),
    (7, 4, 'Combo Gà Rán & Khoai Tây', '3 miếng gà rán giòn rụm kèm khoai tây chiên vàng giòn và sốt tương cà.', 89000, 'img/11.jfif', 1),
    (8, 4, 'Gà Rán Giòn Cay', 'Miếng gà lớn tẩm ướp cay nhẹ đậm vị, lớp vỏ bột giòn rụm khó cưỡng.', 79000, 'img/22.jfif', 1),
    (9, 4, 'Cánh & Đùi Gà Hoàng Gia', 'Khay cánh và đùi gà chiên vàng ươm giòn tan, thịt mềm ngọt mọng nước.', 99000, 'img/33.jfif', 1),
    (10, 5, 'Pepsi Lon Mát Lạnh 320ml', 'Pepsi có gas mát lạnh sảng khoái, giải ngấy hoàn hảo khi ăn pizza và gà rán.', 18000, 'img/pepsi.png', 1),
    (11, 5, 'Coca-Cola Chai Thủy Tinh 330ml', 'Coca-Cola vị truyền thống chai thủy tinh giữ gas cực lâu, ngon tuyệt đỉnh.', 20000, 'img/Coca_Cola_Flasche_-_Original_Taste.jpg', 1),
    (12, 5, 'Fanta Soda Kem Trái Cây 320ml', 'Fanta vị soda kem trái cây thơm lừng, ngọt dịu mát lành cực đã.', 18000, 'img/fanta.webp', 1),
    (13, 6, 'Mì Ý Sốt Bò Bằm Phô Mai', 'Sợi mì Ý dai ngon hòa quyện sốt cà chua thịt bò bằm đậm đà, phủ phô mai sợi thơm béo.', 49000, 'img/jolly_spaghetti_3.jpg', 1),
    (14, 6, 'Combo Mì Ý & Nước Ngọt', 'Phần mì Ý sốt bò bằm phô mai kèm theo 1 ly nước ngọt có gas mát lạnh sảng khoái.', 59000, 'img/spagetti1.jpg', 1),
    (15, 6, 'Khoai Tây Chiên Giòn Rụm', 'Khoai tây chiên vàng ruộm, giòn rụm bên ngoài bùi mịn bên trong ăn kèm tương cà.', 35000, 'img/potato1.jfif', 1),
    (16, 7, 'Combo Tiệc Gà Hẹn Hò (4 Gà + 2 Nước)', 'Ưu đãi sốc giảm 47%: 4 miếng gà rán giòn rụm thơm lừng kèm 2 ly nước ngọt có gas mát lạnh.', 99000, 'img/khuyenmai3.jpg', 1),
    (17, 7, 'Combo Deal Choáy Burger & Gà Popcorn', 'Ưu đãi 89K: 1 Burger gà phi lê giòn tan + 1 miếng Gà giòn + 1 hộp Gà Popcorn lắc vị.', 89000, 'img/khuyenmai5.jpg', 1),
    (18, 7, 'Combo Tiệc Đẫm Chấm Xốt Lắm Chiêu', 'Gà giòn + Gà không xương + Gà viên Popcorn + Khoai tây chiên Cajun kèm xốt chấm đặc quyền.', 99000, 'img/khuyenmai4.jpg', 1),
    (19, 7, 'Combo Pizza Hoàng Kim LAVA Mới', 'Pizza Hoàng Kim viền Lava phô mai chảy béo ngậy kèm salad tươi mát và 4 lon Pepsi mát lạnh.', 389000, 'img/khuyenmai2.webp', 1),
    (20, 7, 'Ưu Đãi Combo Mua 1 Tặng 1 Pizza', 'Mua 1 Pizza bất kỳ cỡ lớn (L) được tặng ngay 1 Pizza cùng cỡ tùy chọn.', 199000, 'img/khuyenmai1.webp', 1),
    (21, 8, 'Mì Cay Hải Sản Kim Chi', 'Mì sợi dai giòn chuẩn Hàn Quốc, tôm sú tươi ngọt, mực giòn, chả cá xoắn và nấm kim châm ngập trong nước súp kim chi chua cay đậm đà bùng nổ vị giác.', 69000, 'img/mi_cay_kim_chi.jpg', 1),
    (22, 8, 'Mì Ramen Xá Xíu Nhật Bản (Tonkotsu)', 'Nước hầm xương heo đậm đặc béo ngậy suốt 12 tiếng, thịt xá xíu cuộn mềm tan trong miệng, trứng lòng đào ngâm tương Ajitsuke Tamago, rong biển Nori và bắp ngọt.', 79000, 'img/mi_ramen_xa_xiu.jpg', 1),
    (23, 8, 'Mì Gà Tiềm Nấm Đông Cô Nước Dùng Thảo Mộc', 'Đùi gà góc tư ninh mềm mọng nước, kết hợp nấm đông cô tươi, kỷ tử, táo đỏ trong nước dùng xương hầm thảo mộc thanh ngọt tự nhiên, bồi bổ sức khỏe.', 75000, 'img/mi_ga_tiem.jpg', 1),
    (24, 8, 'Mì Bò Sa Tế Cay Nồng Nóng Hổi', 'Bắp bò tươi thái mỏng chín tới mềm ngọt, bò viên gân giòn sần sật, sa tế tôm ớt cay nồng thơm lừng cùng cải thìa và hành ngò tươi mát.', 65000, 'img/mi_bo_sa_te.jpg', 1)
ON DUPLICATE KEY UPDATE
    category_id = VALUES(category_id),
    name = VALUES(name),
    description = VALUES(description),
    price = VALUES(price),
    image = VALUES(image),
    status = VALUES(status);


INSERT INTO product_reviews (id, product_id, customer_name, customer_email, rating, comment, admin_reply, admin_replied_at, created_at)
VALUES
    (1, 22, 'Nguyễn Minh Tuấn', 'tuan.nguyen@gmail.com', 5, 'Mì ramen xá xíu cực kỳ ngon, nước dùng xương hầm béo ngậy đúng chuẩn Nhật, thịt xá xíu mềm tan, trứng lòng đào dẻo quánh! 10/10 điểm.', 'Dạ Pizza House cảm ơn anh Tuấn nhiều ạ! Quán luôn ninh xương kỹ 12 tiếng để phục vụ tô ramen thơm ngon nhất đến quý khách. Chúc anh luôn ngon miệng! ❤️', '2026-09-08 10:15:00', '2026-09-08 09:30:00'),
    (2, 22, 'Trần Thu Hà', 'ha.tran@outlook.com', 5, 'Mì giao đến vẫn còn nóng hổi bốc khói, sợi mì dai ngon không bị bở chút nào. Nước súp thanh ngọt đậm đà, đóng gói rất cẩn thận!', 'Cảm ơn bạn Hà đã khen ngợi ạ! Quán luôn đóng gói riêng nước dùng và sợi mì để giữ trọn vị ngon nóng hổi khi giao hàng tận nơi. Hẹn gặp lại bạn nhé!', '2026-09-08 14:00:00', '2026-09-08 13:20:00'),
    (3, 21, 'Lê Hoàng Nam', 'nam.le@gmail.com', 5, 'Tô mì cay kim chi ngập tràn hải sản, tôm tươi chắc thịt, mực giòn sần sật, độ cay vừa phải rất kích thích vị giác!', 'Dạ cảm ơn anh Nam đã đánh giá 5 sao cho món Mì Cay Hải Sản! Quán luôn chọn nguyên liệu tươi sống mỗi ngày ạ.', '2026-09-08 15:30:00', '2026-09-08 15:00:00'),
    (4, 21, 'Phạm Ngọc Bích', 'bich.pham@gmail.com', 4, 'Mì cay ngon, nước súp kim chi đậm đà chuẩn vị Hàn. Nếu quán cho thêm nhiều nấm kim châm hơn chút nữa thì tuyệt vời luôn.', 'Pizza House cảm ơn góp ý quý báu của chị Bích ạ! Lần tới đặt hàng chị cứ ghi chú thêm nấm, quán sẽ ưu tiên phục vụ chị chu đáo nhất nhé ạ!', '2026-09-08 17:00:00', '2026-09-08 16:15:00'),
    (5, 1, 'Hoàng Lan', 'lan.hoang@yahoo.com', 5, 'Đế bánh nướng củi thơm lừng, xốp giòn, sốt cà chua tươi và phô mai kéo sợi thơm ngậy ăn hoài không ngán!', 'Cảm ơn bạn Lan đã yêu thích hương vị Pizza Margherita truyền thống của Pizza House ạ!', '2026-09-07 19:20:00', '2026-09-07 18:40:00'),
    (6, 16, 'Đỗ Quốc Bảo', 'bao.do@gmail.com', 5, 'Combo 99k 4 miếng gà kèm 2 nước quá hời! Gà rán giòn rụm bên ngoài, thịt mềm ngọt mọng nước bên trong, nước sốt chấm tuyệt vời.', 'Dạ Pizza House cảm ơn anh Bảo đã ủng hộ tiệc gà 99K ạ! Chúc anh có những bữa tiệc thật vui cùng gia đình và bạn bè nhé!', '2026-09-07 20:45:00', '2026-09-07 20:10:00')
ON DUPLICATE KEY UPDATE
    comment = VALUES(comment),
    admin_reply = VALUES(admin_reply);
