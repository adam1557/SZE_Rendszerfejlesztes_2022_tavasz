/* By: Karcag Tamas (DT0QPB) */
/* Database */
drop
    database if exists library;
create
    database library collate utf8mb4_hungarian_ci;

use
    library;

/* Tables */

create table address
(
    id       int auto_increment primary key not null,
    city     varchar(60)                    not null,
    zip_code varchar(10),
    street   varchar(60),
    number   varchar(10)
);

/* Book publisher */
create table publisher
(
    id   int auto_increment primary key,
    name varchar(80) not null
);

/* Library Roles */
create table role
(
    id    int(3) auto_increment primary key,
    title varchar(40) not null
);

/* User */
create table user
(
    id              int auto_increment primary key,
    name            varchar(60) not null,
    email           varchar(80) not null,
    registration    datetime    not null default NOW(),
    registered_by   int         null,
    role_id         int(3)      not null,
    disabled        bit         not null default 0,
    expiration      datetime    not null default ADDDATE(NOW(), 6 * 30),
    validated       bit         not null default 0,
    email_confirmed bit         not null default 0,
    constraint user_role_id_fk foreign key (role_id) references role (id) on delete restrict,
    constraint user_registered_by_fk foreign key (registered_by) references user (id) on delete set null
);

/* Parent */
create table parent
(
    id      int auto_increment primary key,
    user_id int null,
    constraint parent_user_id_fk foreign key (user_id) references user (id) on delete restrict
);

/* Parent data */
create table parent_data
(
    id          int primary key,
    name        varchar(60) not null,
    email       varchar(80) not null,
    address_id  int         not null,
    birth       date        not null,
    birth_place varchar(10) not null,
    tel         varchar(20) not null,
    constraint parent_data_id_fk foreign key (id) references parent (id) on delete cascade,
    constraint parent_data_address_id_fk foreign key (address_id) references address (id) on delete restrict
);

/* User data */
create table user_data
(
    id           int         not null,
    mothers_name varchar(80) not null,
    tel          varchar(20) not null,
    birth        date        not null,
    birth_place  varchar(10) not null,
    address_id   int         not null,
    parent_id    int         null,
    constraint user_data_id_fk foreign key (id) references user (id) on delete cascade,
    constraint user_data_address_id_fk foreign key (address_id) references address (id) on delete restrict,
    constraint user_data_parent_id_fk foreign key (parent_id) references parent (id) on delete cascade
);

/* Book writer */
create table writer
(
    id   int auto_increment primary key,
    name varchar(100) not null
);

/* Book data */
create table book_data
(
    isbn          varchar(20)  not null,
    title         varchar(120) not null,
    publisher_id  int          not null,
    publish       date         not null,
    original_cost decimal      not null default 0,
    primary key (isbn),
    constraint book_publisher_id_fk foreign key (publisher_id) references publisher (id) on delete restrict
);

/* Book */
create table book
(
    id               int auto_increment primary key,
    code             varchar(30) not null,
    max_rent_in_days int         not null default 14,
    is_scrap         bit         not null default 0,
    is_damaged       bit         not null default 0,
    data_id          varchar(20) not null,
    constraint book_code_uindex unique (code),
    constraint book_data_id_fk foreign key (data_id) references book_data (isbn) on delete restrict
);

/* Book Writer */
create table book_writer
(
    book_id   int not null,
    writer_id int not null,
    primary key (book_id, writer_id),
    constraint book_writer_book_id_fk foreign key (book_id) references book (id) on delete cascade,
    constraint book_writer_writer_id_fk foreign key (writer_id) references writer (id) on delete restrict
);

/* Reader Ticket */
create table reader_ticket
(
    id         int auto_increment primary key,
    serial_key varchar(33) not null unique,
    user_id    int         not null,
    creation   datetime    not null default NOW(),
    expired    bit         not null default 0,
    is_temp    bit         not null default 0,
    constraint reader_ticket_user_id_fk foreign key (user_id) references user (id) on delete restrict
);

/* Header of book rent */
create table rent_header
(
    id         int auto_increment primary key,
    ticket_id  int      not null,
    rent_date  datetime not null,
    expiration datetime not null,
    constraint rent_ticket_id_fk foreign key (ticket_id) references reader_ticket (id) on delete restrict
);

/* Rent */
create table rent
(
    header_id int      not null,
    book_id   int      not null,
    end_date  datetime null,
    primary key (header_id, book_id),
    constraint rent_book_id_fk foreign key (book_id) references book (id) on delete restrict,
    constraint rent_rent_header_id_fk foreign key (header_id) references rent_header (id) on delete restrict
);

/* Penalty */
create table penalty
(
    id      int auto_increment primary key not null,
    user_id int                            not null,
    date    datetime                       not null default NOW(),
    cost    decimal                        not null default 0,
    constraint penalty_user_id_fk foreign key (user_id) references user (id) on delete restrict
);

/* Penalty item */
create table penalty_item
(
    id         int auto_increment primary key not null,
    penalty_id int                            not null,
    book_id    int                            not null,
    constraint penalty_item_penalty_id_fk foreign key (penalty_id) references penalty (id) on delete cascade,
    constraint penalty_item_book_id_fk foreign key (book_id) references book (id) on delete cascade
);

create table log_event
(
    id          int auto_increment primary key not null,
    name        varchar(30)                    not null,
    description varchar(120)                   null
);

create table audit_log
(
    id       int auto_increment primary key not null,
    event_id int                            not null,
    date     datetime                       not null,
    message  varchar(200),
    user_id  int                            null,
    constraint audit_log_event_id_fk foreign key (event_id) references log_event (id) on delete restrict,
    constraint audit_log_user_id_fk foreign key (user_id) references user (id) on delete set null
);

/* Data */
insert role (id, title)
values (1, 'Administrator'),
       (2, 'Director'),
       (3, 'Librarian'),
       (4, 'Customer');

alter table user
    modify column role_id int not null default 4;




