---insert role names
INSERT INTO roles (role_name)
VALUES
  ('Host'),
  ('Guest'),
  ('Admin');

--- Insert Users
INSERT INTO users (first_name, last_name, email, password_hash, phone_number)
VALUES
  ('John', 'Doe', 'john.doe@example.com', 'hashed_password1', '+441234567890'),
  ('Jane', 'Smith', 'jane.smith@example.com', 'hashed_password2', '+447890123456'),
  ('Alice', 'Brown', 'alice.brown@example.com', 'hashed_password3', '+447765432109');

--- Insert user roles

INSERT INTO user_roles (user_id, role_id)
SELECT u.user_id, r.role_id
FROM users u
JOIN roles r ON r.role_name = 'Host'
WHERE u.email = 'john.doe@example.com'
UNION ALL
SELECT u.user_id, r.role_id
FROM users u
JOIN roles r ON r.role_name = 'Guest'
WHERE u.email = 'jane.smith@example.com'
UNION ALL
SELECT u.user_id, r.role_id
FROM users u
JOIN roles r ON r.role_name = 'Admin'
WHERE u.email = 'alice.brown@example.com';

--- create multiple roles for some users
INSERT INTO user_roles (user_id, role_id)
SELECT u.user_id, r.role_id
FROM users u
JOIN roles r ON r.role_name = 'Guest'
WHERE u.email = 'john.doe@example.com'
UNION ALL
SELECT u.user_id, r.role_id
FROM users u
JOIN roles r ON r.role_name = 'Host'
WHERE u.email = 'alice.brown@example.com';

--- Insert Properties
INSERT INTO properties (host_id, name, description, location, price_per_night, created_at, updated_at)
SELECT user_id, 'Modern Apartment', 'A cozy 2-bedroom apartment in central London.', 'London, UK', 120.00, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM users WHERE email = 'john.doe@example.com'
UNION ALL
SELECT user_id, 'Beachside Villa', 'Spacious villa with ocean views.', 'Brighton, UK', 250.00, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM users WHERE email = 'john.doe@example.com';

--- Insert Bookings status
INSERT INTO booking_status (booking_status_description)
VALUES
  ('Pending'),
  ('Confirmed'),
  ('Cancelled');

--- Insert Bookings
INSERT INTO bookings (property_id, user_id, start_date, end_date, total_price, booking_status_id, created_at)
SELECT p.property_id, u.user_id, DATE '2024-07-01', DATE '2024-07-05', 480.00, bs.booking_status_id, CURRENT_TIMESTAMP
FROM properties p
JOIN users u ON u.email = 'john.doe@example.com'
JOIN booking_status bs ON bs.booking_status_description = 'Confirmed'
WHERE p.name = 'Modern Apartment'
UNION ALL
SELECT p.property_id, u.user_id, DATE '2024-08-10', DATE '2024-08-15', 1250.00, bs.booking_status_id, CURRENT_TIMESTAMP
FROM properties p
JOIN users u ON u.email = 'jane.smith@example.com'
JOIN booking_status bs ON bs.booking_status_description = 'Pending'
WHERE p.name = 'Beachside Villa';

--- Insert payments_methods
INSERT INTO payment_methods (method_name)
VALUES
  ('Credit Card'),
  ('PayPal'),
  ('Bank Transfer');

--- Insert Payments
INSERT INTO payments (booking_id, amount, payment_date, payment_method_id)
SELECT b.booking_id, 480.00, DATE '2024-08-02', pm.payment_method_id
FROM bookings b
JOIN Payment_methods pm ON pm.payment_method_description = 'Credit Card'
WHERE b.booking_id = '4b219bc5-1280-4f70-a7c6-d860ba8d0d12'
UNION ALL
SELECT b.booking_id, 1250.00, DATE '2024-08-03', pm.payment_method_id
FROM bookings b
JOIN Payment_methods pm ON pm.payment_method_description = 'PayPal'
WHERE b.booking_id = 'a3b8ee2d-01c8-493f-bbd3-0b4cd2709271';

--- insert Reviews
INSERT INTO reviews (property_id, user_id, rating, comment, created_at)
SELECT p.property_id, u.user_id, 5, 'Amazing stay! Highly recommend.', CURRENT_TIMESTAMP
FROM properties p
JOIN users u ON u.email = 'john.doe@example.com'
WHERE p.name = 'Modern Apartment'
UNION ALL
SELECT p.property_id, u.user_id, 4, 'Great location but a bit noisy.', CURRENT_TIMESTAMP
FROM properties p
JOIN users u ON u.email = 'jane.smith@example.com'
WHERE p.name = 'Beachside Villa';

--- insert messages
INSERT INTO messages (sender_id, recipient_id, message_body, sent_at)
SELECT su.user_id, ru.user_id, 'Hello, I would like to inquire about your property.', CURRENT_TIMESTAMP
FROM users su
JOIN users ru ON ru.email = 'john.doe@example.com'
WHERE su.email = 'jane.smith@example.com'
UNION ALL
SELECT su.user_id, ru.user_id, 'Thank you for your inquiry. The property is available.', CURRENT_TIMESTAMP
FROM users su
JOIN users ru ON ru.email = 'jane.smith@example.com'
WHERE su.email = 'john.doe@example.com';

