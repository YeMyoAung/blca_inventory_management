## DB Digaram
https://dbdocs.io/YeMyoAung/test

## Extension Id
vaughan.rdoc-readme

## Normal Query
Pattern 
```sql
select 
    "column1","column2"
from
    "tableName";
```

## Where Query 
Pattern
```sql
select 
    "column1","column2"
from 
    "tableName"
where
    "columnName" = 'value';
```
Operator
```sql
    = (equal)
    != (not equal)
    > (less than)
    < (greater than)
    like (case like)
    ilike (like) (a%,%a,%a%)
    is null
    is not null
    in (array)
    between a,b
```

## Join Query
Pattern
```sql
select 
    "columnName"
from "table1Name"
join "table2Name" on "table1Name"."id"="table2Name"."id" 
join "table3Name" on "table1Name"."id"="table3Name"."id";
```

Operator
```sql
    join 
    left join 
```

## Sub Query
Pattern
```sql
select 
    "columnName",
    (Normal Query) as "setName"
from tableName;
```