# Apex SimpleQueryBuilder

### Example 1: The Basic Query

#### SOQL
```
SELECT Id, Name, CloseDate, StageName 
FROM Opportunity
```

#### QueryBuilder
```
new QueryBuilder(Opportunity.SObjectType)
    .selectFields(new SObjectField[] {
      Opportunity.Id,
      Opportunity.Name,
      Opportunity.CloseDate,
      Opportunity.StageName
    })
.toString();
```
### Example 2: Subqueries (parent-to-child)

#### SOQL
```
SELECT Id, (SELECT Name FROM Opportunities) 
FROM Account
```

#### QueryBuilder
```
new QueryBuilder(Account.SObjectType)
    .selectField(Account.Id)
    .subQuery(new QueryBuilder(Opportunity.SObjectType)
        .selectField(Opportunity.Name)
    )
.toString();
```

### Example 3: Complex Single Object Query

#### SOQL
```
SELECT Id, Name, CloseDate, StageName
FROM Opportunity
WHERE
      CloseDate = TODAY
      AND StageName = 'Closed Won'
      AND Amount > 100
      AND (
          ( NextStep != null
            AND IsPrivate = false
            AND Name LIKE '%(IT)%' )
          OR
          Type != null
      )
ORDER BY Name ASC 
LIMIT 5
OFFSET 3
```    

#### QueryBuilder
```
new QueryBuilder(Opportunity.SObjectType)
  .selectFields(new SObjectField[] {
      Opportunity.Id,
      Opportunity.Name,
      Opportunity.CloseDate,
      Opportunity.StageName
  })
  .whereClause(new QueryCondition()
      .isToday(Opportunity.CloseDate)                                   
      .equals(Opportunity.StageName, 'Closed Won')                  
      .greaterThan(Opportunity.Amount, 100)                            
      .andGroup(new QueryCondition()                               
        .group(new QueryCondition()                                 
          .isNotNull(Opportunity.NextStep)                             
          .isFalse(Opportunity.IsPrivate)                               
          .isLike(Opportunity.Name, '%(IT)%')                           
        )
      .orCondition(new QueryCondition().isNotNull(Opportunity.Type))
    )
  )
  .orderBy(Opportunity.Name, 'ASC')
  .take(5)
  .skip(3)
.toString();
```
