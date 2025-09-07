create table store_api.leetest
(
    id    int         not null
        primary key,
    value varchar(10) not null,
    constraint `unique status`
        unique (value)
);

create index leetest_value_index
    on store_api.leetest (value desc);

