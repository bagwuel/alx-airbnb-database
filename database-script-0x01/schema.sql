-- ============================================================
-- AIRBNB DATABASE SCHEMA - POSTGRESQL VERSION
-- ============================================================

-- Enable UUID generation extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================
-- USERS & ROLES
-- ============================================================

CREATE TABLE Users (
    user_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Roles (
    role_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    role_name VARCHAR(100) NOT NULL
);

CREATE TABLE User_Roles (
    user_role_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    role_id UUID NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (role_id) REFERENCES Roles(role_id) ON DELETE CASCADE
);

-- ============================================================
-- PROPERTY & HOSTS
-- ============================================================

CREATE TABLE Properties (
    property_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    host_id UUID NOT NULL,
    name VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    location VARCHAR(255) NOT NULL,
    price_per_night DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (host_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- ============================================================
-- BOOKING STATUS
-- ============================================================

CREATE TABLE Booking_Status (
    booking_status_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    booking_status_description VARCHAR(100) NOT NULL
);

-- ============================================================
-- BOOKINGS
-- ============================================================

CREATE TABLE Bookings (
    booking_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    booking_status_id UUID NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (property_id) REFERENCES Properties(property_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (booking_status_id) REFERENCES Booking_Status(booking_status_id) ON DELETE SET NULL
);

-- ============================================================
-- PAYMENT METHODS
-- ============================================================

CREATE TABLE Payment_Methods (
    payment_method_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    payment_method_description VARCHAR(100) NOT NULL
);

-- ============================================================
-- PAYMENTS
-- ============================================================

CREATE TABLE Payments (
    payment_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    booking_id UUID NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method_id UUID NOT NULL,
    FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id) ON DELETE CASCADE,
    FOREIGN KEY (payment_method_id) REFERENCES Payment_Methods(payment_method_id) ON DELETE SET NULL
);

-- ============================================================
-- REVIEWS
-- ============================================================

CREATE TABLE Reviews (
    review_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (property_id) REFERENCES Properties(property_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- ============================================================
-- MESSAGES
-- ============================================================

CREATE TABLE Messages (
    message_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sender_id UUID NOT NULL,
    recipient_id UUID NOT NULL,
    message_body TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sender_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (recipient_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- ============================================================
-- INDEXES (some are automatic; these are extras)
-- ============================================================

CREATE INDEX idx_users_email ON Users(email);
CREATE INDEX idx_properties_host_id ON Properties(host_id);
CREATE INDEX idx_bookings_property_id ON Bookings(property_id);
CREATE INDEX idx_bookings_user_id ON Bookings(user_id);
CREATE INDEX idx_payments_booking_id ON Payments(booking_id);

-- ============================================================
-- SAMPLE DATA (optional)
-- ============================================================

INSERT INTO Roles (role_name) VALUES ('Host'), ('Guest'), ('Admin');

INSERT INTO Booking_Status (booking_status_description)
VALUES ('Pending'), ('Confirmed'), ('Cancelled');

INSERT INTO Payment_Methods (payment_method_description)
VALUES ('Credit Card'), ('PayPal'), ('Bank Transfer');
