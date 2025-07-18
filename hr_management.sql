-- Tạo database
CREATE DATABASE IF NOT EXISTS hr_management;
USE hr_management;

-- ============================
-- Bảng: departments (Phòng ban)
-- ============================
CREATE TABLE departments (
    id INT AUTO_INCREMENT PRIMARY KEY,      -- Mã phòng ban, tự tăng, khóa chính
    name VARCHAR(100) NOT NULL,             -- Tên phòng ban, bắt buộc nhập
    description TEXT                        -- Mô tả phòng ban (tùy chọn)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================
-- Bảng: positions (Chức vụ)
-- ============================
CREATE TABLE positions (
    id INT AUTO_INCREMENT PRIMARY KEY,      -- Mã chức vụ, tự tăng
    title VARCHAR(100) NOT NULL,            -- Tên chức vụ (VD: Nhân viên, Trưởng phòng)
    allowance DECIMAL(10,2) DEFAULT 0       -- Mức phụ cấp, mặc định 0 nếu không có
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================
-- Bảng: employees (Nhân viên)
-- ============================
CREATE TABLE employees (
    id INT AUTO_INCREMENT PRIMARY KEY,                    -- Mã nhân viên (tự động tăng)
    employee_code VARCHAR(20) NOT NULL UNIQUE,            -- Mã số nhân viên, duy nhất và bắt buộc
    full_name VARCHAR(100) NOT NULL,                      -- Họ và tên
    gender ENUM('Male', 'Female', 'Other') DEFAULT 'Male',-- Giới tính, chỉ nhận 1 trong 3 giá trị
    birth_date DATE,                                      -- Ngày sinh
    address TEXT,                                         -- Địa chỉ
    phone VARCHAR(20),                                    -- Số điện thoại
    email VARCHAR(100),                                   -- Email
    department_id INT,                                    -- Mã phòng ban (khóa ngoại)
    position_id INT,                                      -- Mã chức vụ (khóa ngoại)
    hire_date DATE,                                       -- Ngày bắt đầu làm việc
    base_salary DECIMAL(12,2),                            -- Lương cơ bản
    avatar VARCHAR(255),                                  -- Ảnh đại diện (đường dẫn file)
    FOREIGN KEY (department_id) REFERENCES departments(id), -- Ràng buộc phòng ban tồn tại
    FOREIGN KEY (position_id) REFERENCES positions(id)       -- Ràng buộc chức vụ tồn tại
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================
-- Bảng: users (Tài khoản đăng nhập)
-- ============================
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,                     -- Mã tài khoản, tự tăng
    username VARCHAR(50) UNIQUE NOT NULL,                  -- Tên đăng nhập duy nhất, bắt buộc
    password VARCHAR(255) NOT NULL,                        -- Mật khẩu (đã mã hóa), bắt buộc
    role ENUM('Admin', 'User') DEFAULT 'User',             -- Quyền truy cập, mặc định là User
    employee_id INT,                                       -- Gắn với mã nhân viên (nếu có)
    FOREIGN KEY (employee_id) REFERENCES employees(id)     -- Ràng buộc nhân viên tồn tại
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================
-- Bảng: attendance (Chấm công)
-- ============================
CREATE TABLE attendance (
    id INT AUTO_INCREMENT PRIMARY KEY,        -- Mã chấm công, tự động tăng
    employee_id INT,                          -- Mã nhân viên (khóa ngoại)
    work_date DATE,                           -- Ngày làm việc
    checkin TIME,                             -- Giờ vào
    checkout TIME,                            -- Giờ ra
    note TEXT,                                -- Ghi chú (tùy chọn)
    FOREIGN KEY (employee_id) REFERENCES employees(id)  -- Ràng buộc nhân viên tồn tại
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================
-- Bảng: payroll (Lương)
-- ============================
CREATE TABLE payroll (
    id INT AUTO_INCREMENT PRIMARY KEY,                          -- Mã bảng lương
    employee_id INT,                                            -- Mã nhân viên
    month INT,                                                  -- Tháng tính lương
    year INT,                                                   -- Năm tính lương
    work_days INT,                                              -- Số ngày công trong tháng
    total_salary DECIMAL(12,2),                                 -- Tổng lương nhận được
    status ENUM('Paid', 'Unpaid') DEFAULT 'Unpaid',             -- Trạng thái thanh toán, mặc định là chưa thanh toán
    FOREIGN KEY (employee_id) REFERENCES employees(id)          -- Ràng buộc nhân viên tồn tại
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================
-- Bảng: leaves (Nghỉ phép)
-- ============================
CREATE TABLE leaves (
    id INT AUTO_INCREMENT PRIMARY KEY,                          -- Mã đơn nghỉ phép
    employee_id INT,                                            -- Mã nhân viên
    start_date DATE,                                            -- Ngày bắt đầu nghỉ
    end_date DATE,                                              -- Ngày kết thúc nghỉ
    reason TEXT,                                                -- Lý do nghỉ
    status ENUM('Pending', 'Approved', 'Rejected') DEFAULT 'Pending', -- Trạng thái phê duyệt
    FOREIGN KEY (employee_id) REFERENCES employees(id)          -- Ràng buộc nhân viên tồn tại
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================
-- Bảng: contracts (Hợp đồng lao động)
-- ============================
CREATE TABLE contracts (
    id INT AUTO_INCREMENT PRIMARY KEY,                          -- Mã hợp đồng
    employee_id INT,                                            -- Mã nhân viên
    contract_type VARCHAR(100),                                 -- Loại hợp đồng (thời vụ, dài hạn...)
    start_date DATE,                                            -- Ngày bắt đầu hợp đồng
    end_date DATE,                                              -- Ngày kết thúc hợp đồng
    salary DECIMAL(12,2),                                       -- Mức lương trong hợp đồng
    note TEXT,                                                  -- Ghi chú thêm
    FOREIGN KEY (employee_id) REFERENCES employees(id)          -- Ràng buộc nhân viên tồn tại
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================
-- Bảng: insurance (Bảo hiểm)
-- ============================
CREATE TABLE insurance (
    id INT AUTO_INCREMENT PRIMARY KEY,                          -- Mã hồ sơ bảo hiểm
    employee_id INT,                                            -- Mã nhân viên
    insurance_type VARCHAR(100),                                -- Loại bảo hiểm (VD: BHXH, BHYT)
    register_date DATE,                                         -- Ngày đăng ký
    insurance_code VARCHAR(50),                                 -- Mã số bảo hiểm
    status ENUM('Active', 'Inactive') DEFAULT 'Active',         -- Trạng thái bảo hiểm
    FOREIGN KEY (employee_id) REFERENCES employees(id)          -- Ràng buộc nhân viên tồn tại
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================
-- Bảng: rewards_punishments (Khen thưởng/Kỷ luật)
-- ============================
CREATE TABLE rewards_punishments (
    id INT AUTO_INCREMENT PRIMARY KEY,                          -- Mã bản ghi
    employee_id INT,                                            -- Mã nhân viên
    type ENUM('Reward', 'Discipline') NOT NULL,                 -- Loại (khen thưởng hoặc kỷ luật)
    title VARCHAR(100),                                         -- Tiêu đề
    content TEXT,                                               -- Nội dung chi tiết
    date DATE,                                                  -- Ngày áp dụng
    FOREIGN KEY (employee_id) REFERENCES employees(id)          -- Ràng buộc nhân viên tồn tại
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================
-- Bảng: shifts (Ca làm việc)
-- ============================
CREATE TABLE shifts (
    id INT AUTO_INCREMENT PRIMARY KEY,         -- Mã ca
    shift_name VARCHAR(50),                    -- Tên ca (Ca sáng, Ca tối...)
    start_time TIME,                           -- Thời gian bắt đầu ca
    end_time TIME                              -- Thời gian kết thúc ca
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================
-- Bảng: work_schedule (Phân ca)
-- ============================
CREATE TABLE work_schedule (
    id INT AUTO_INCREMENT PRIMARY KEY,         -- Mã lịch làm việc
    employee_id INT,                           -- Mã nhân viên
    shift_id INT,                              -- Mã ca làm việc
    work_date DATE,                            -- Ngày làm
    FOREIGN KEY (employee_id) REFERENCES employees(id), -- Ràng buộc nhân viên tồn tại
    FOREIGN KEY (shift_id) REFERENCES shifts(id)        -- Ràng buộc ca làm việc tồn tại
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================
-- Bảng: activity_logs (Nhật ký hoạt động)
-- ============================
CREATE TABLE activity_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,         -- Mã bản ghi nhật ký
    user_id INT,                               -- Mã người dùng thực hiện hành động
    action VARCHAR(255),                       -- Hành động được ghi lại (VD: login, sửa nhân viên...)
    log_time DATETIME DEFAULT CURRENT_TIMESTAMP, -- Thời điểm thực hiện hành động
    FOREIGN KEY (user_id) REFERENCES users(id) -- Ràng buộc tài khoản tồn tại
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
