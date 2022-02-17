/* Database */
drop database if exists library;
create database library collate utf8mb4_hungarian_ci;

use library;

/* Tables */
create table publisher
(
    id   int auto_increment primary key,
    name int not null
);

create table role
(
    id    int auto_increment primary key,
    title varchar(80) not null
);

create table user
(
    id           int auto_increment primary key,
    name         varchar(60) not null,
    address      varchar(255) not null,
    tel          varchar(20) not null,
    birth        date         null,
    email        varchar(80) not null,
    registration datetime     not null,
    roleId       int          not null,
    constraint user_role_id_fk foreign key (roleId) references role (id)
);

create table writer
(
    id   int auto_increment primary key,
    name varchar(100) not null
);

create table book
(
    id                int auto_increment primary key,
    title             varchar(120) not null,
    writerId          int          not null,
    publisherId       int          not null,
    publish           date         not null,
    isbn              varchar(20)  not null,
    code              varchar(30) not null,
    maxRentInDays     int          not null default 14,
    isScrap           bit          not null default 0,
    constraint book_isbn_uindex unique (isbn),
    constraint book_publisher_id_fk foreign key (publisherId) references publisher (id),
    constraint book_writer_id_fk foreign key (writerId) references writer (id)
);

create table rentHeader
(
    id         int auto_increment primary key,
    userId     int      not null,
    rentDate   datetime not null,
    expiration datetime not null,
    constraint rent_user_id_fk foreign key (userId) references user (id)
);

create table rent
(
    rentHeaderId     int      not null,
    bookId     int      not null,
    endDate    datetime null,
    primary key (rentHeaderId, bookId),
    constraint rent_book_id_fk foreign key (bookId) references book (id),
    constraint rent_rentHeader_id_fk foreign key (rentHeaderId) references rentHeader (id)
);

/* Data */
insert role (id, title)
values (1, 'Administrator'),
       (2, 'Director'),
       (3, 'Librarian'),
       (4, 'Customer');

alter table user modify column roleId int not null default 4;

