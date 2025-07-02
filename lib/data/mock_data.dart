class MockData {
  static final Map<String, dynamic> data = {
    "auth": {
      "register": {
        "phone": "0123456789",
        "password": "password123",
        "email": "user@example.com",
        "response": {
          "user": {
            "id": "user_new",
            "phone": "0123456789",
            "email": "user@example.com",
            "name": "Nguyen Van A",
            "role": "customer"
          }
        }
      },
      "login": {
        "phone": "0123456789",
        "password": "password123",
        "response": {
          "access_token": "jwt_token_example",
          "refresh_token": "refresh_token_example",
          "user": {
            "id": "user_1",
            "phone": "0123456789",
            "email": "user@example.com",
            "name": "Nguyen Van A",
            "role": "customer"
          }
        }
      }
    },
    "users": [
      {
        "id": "user_1",
        "phone": "0123456789",
        "email": "user1@example.com",
        "role": "customer",
        "name": "Nguyen Van A"
      },
      {
        "id": "user_2",
        "phone": "0987654321",
        "email": "user2@example.com",
        "role": "admin",
        "name": "Tran Thi B"
      }
    ],
    "restaurants": [
      {
        "id": "res_1",
        "name": "Quán Phở Hà Nội",
        "address": "123 Đường Láng, Hà Nội",
        "image": "pho_hanoi.jpg",
        "rating": 4.5,
        "category_ids": ["cat_1"],
        "delivery_time": "20-30 phút"
      },
      {
        "id": "res_2",
        "name": "Cơm Tấm Sài Gòn",
        "address": "456 Nguyễn Huệ, TP.HCM",
        "image": "com_tam_sg.jpg",
        "rating": 4.2,
        "category_ids": ["cat_2"],
        "delivery_time": "25-35 phút"
      },
      {
        "id": "res_3",
        "name": "Cơm Tấm Sài Gòn",
        "address": "456 Nguyễn Huệ, TP.HCM",
        "image": "com_tam_sg.jpg",
        "rating": 4.2,
        "category_ids": ["cat_2"],
        "delivery_time": "25-35 phút"
      },
      {
        "id": "res_4",
        "name": "Cơm Tấm Sài Gòn",
        "address": "456 Nguyễn Huệ, TP.HCM",
        "image": "com_tam_sg.jpg",
        "rating": 4.2,
        "category_ids": ["cat_2"],
        "delivery_time": "25-35 phút"
      },
      {
        "id": "res_5",
        "name": "Cơm Tấm Sài Gòn",
        "address": "456 Nguyễn Huệ, TP.HCM",
        "image": "com_tam_sg.jpg",
        "rating": 4.2,
        "category_ids": ["cat_2"],
        "delivery_time": "25-35 phút"
      },
      {
        "id": "res_6",
        "name": "Cơm Tấm Sài Gòn",
        "address": "456 Nguyễn Huệ, TP.HCM",
        "image": "com_tam_sg.jpg",
        "rating": 4.2,
        "category_ids": ["cat_2"],
        "delivery_time": "25-35 phút"
      },
      {
        "id": "res_7",
        "name": "Cơm Tấm Sài Gòn",
        "address": "456 Nguyễn Huệ, TP.HCM",
        "image": "com_tam_sg.jpg",
        "rating": 4.2,
        "category_ids": ["cat_2"],
        "delivery_time": "25-35 phút"
      }
    ],
    "products": [
      {
        "id": "product_1",
        "name": "Phở Bò",
        "price": 50000,
        "restaurant_id": "res_1",
        "category_id": "cat_1",
        "description": "Phở bò truyền thống",
        "image": "pho_bo.jpg"
      },
      {
        "id": "product_2",
        "name": "Cơm Tấm",
        "price": 40000,
        "restaurant_id": "res_2",
        "category_id": "cat_2",
        "description": "Cơm tấm sườn nướng",
        "image": "com_tam.jpg"
      }
    ],
    "categories": [
      {"id": "cat_1", "name": "Món Nước", "image": "mon_nuoc.jpg"},
      {"id": "cat_2", "name": "Món Khô", "image": "mon_kho.jpg"}
    ],
  };
}