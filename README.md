# Apex SimpleQueryBuilder

<a name="index_block"></a>

* [1. Building Queries](#block1)
    * [1.1. SELECT Statement](#block1.1)     
        * [1.1.1. Basic SELECT statement](#block1.1.1) 
        * [1.1.2. SELECT with WHERE statement](#block1.1.2)
        * [1.1.3. SELECT with aggregate functions](#block1.1.3)
        * [1.1.4. SELECT with related fields (cross-object SOQL query)](#block1.1.4)
        * [1.1.5. SELECT Complex Single Object](#block1.1.5)
    * [1.2. Conditions](#block1.2)
        * [1.2.1. Comparison Operators](#block1.2.1)
        * [1.2.2. Logical Operators](#block1.2.2)  
            * [1.2.1.1. AND Comparison Operator](#block1.2.2.1) 
            * [1.2.1.2. AND Grouped Comparison Operator](#block1.2.2.2)
            * [1.2.1.3. OR Comparison Operator](#block1.2.2.3)
            * [1.2.1.4. OR Grouped Comparison Operator](#block1.2.2.4)
    * [1.3. Subqueries (parent-to-child)](#block1.3)
* [2. Authors](#block2)
* [3. License](#block3)

<a name="block1"></a>
## 1. Building Queries [↑](#index_block)
<a name="block1.1"></a>
### 1.1. SELECT Statement
Fields can either be passed in as singular values using ```selectField()``` or alternatively a list of field references can be passed in via ```selectFields()```.
<a name="block1.1.1"></a>
#### 1.1.1. Basic SELECT statement

SOQL
```sql
SELECT Id, Name, CloseDate, StageName 
FROM Opportunity
```

QueryBuilder
```apex
new QueryBuilder(Opportunity.SObjectType)
    .selectFields(new SObjectField[] {
      Opportunity.Id,
      Opportunity.Name,
      Opportunity.CloseDate,
      Opportunity.StageName
    })
.toString();
```
<a name="block1.1.2"></a>
#### 1.1.2. SELECT with WHERE statement
To construct the where clause in a given query a ```QueryCondition``` object reference is used to build out the condition statements.

SOQL
```sql
SELECT Id, Name, CloseDate, StageName 
FROM Opportunity
WHERE Amount > 100
```
QueryBuilder
```apex
new QueryBuilder(Opportunity.SObjectType)
    .selectFields(new SObjectField[] {
        Opportunity.Id,
        Opportunity.Name,
        Opportunity.CloseDate,
        Opportunity.StageName
    })
    .whereClause(new QueryCondition()
        .greaterThan(Opportunity.Amount, 100)
    )
.toString();
```
<a name="block1.1.3"></a>
#### 1.1.3. SELECT with aggregate functions
All SOQL aggregate functions are supported. Aliases can be passed in as a second parameter.

SOQL
```sql
SELECT AVG(Amount), MIN(Amount), MAX(Amount), SUM(Amount), COUNT(Id), COUNT_DISTINCT(Id)
FROM Opportunity
```

QueryBuilder
```apex
new QueryBuilder(Opportunity.SObjectType)
    .selectAverageField(Opportunity.Amount)
    .selectMinField(Opportunity.Amount)
    .selectMaxField(Opportunity.Amount)
    .selectSumField(Opportunity.Amount)
    .count(Opportunity.Id)
    .selectCountDistinctField(Opportunity.Type)
.toString();
```
<a name="block1.1.4"></a>
#### 1.1.4. SELECT with related fields (cross-object SOQL query)
Cross-object SOQL queries are supported without the need to hardcode string references to related fields. Related fields can be added individually via ```selectRelatedField()``` or as a list of related fields via ```selectRelatedFields()```. The first parameter is the lookup field reference, the second is the field reference or a list of field references on the parent object.

SOQL
```sql
SELECT Name, Account.NumberOfEmployees
FROM Contact
```

QueryBuilder
```apex
new QueryBuilder(Contact.SObjectType)
    .selectField(Contact.Name)
    .selectRelatedField(Contact.Account, Account.NumberOfEmployees)
.toString();
```

<a name="block1.1.5"></a>
#### 1.1.5. SELECT Complex Single Object

SOQL
```sql
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

QueryBuilder
```apex
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

<a name="block1.2"></a>
### 1.2. Conditions [↑](#index_block)
<a name="block1.2.1"></a>
#### 1.2.1. Comparison Operators

SOQL
```sql
WHERE
    Name = 'Joe Bloggs'
    AND Birthdate = 1970-01-1
    AND DoNotCall = False
    AND HasOptedOutOfEmail = True
    AND Title != NULL
```    


QueryBuilder
```apex
  .whereClause(new QueryCondition()
      .equals(Contact.Name, 'Joe Bloggs',
      .equals(Contact.Birthdate, Date.today())
      .isFalse(Contact.DoNotCall)
      .isTrue(Contact.HasOptedOutOfEmail)
      .isNotNull(Contact.Title)
  )
```

<a name="block1.2.2"></a>
#### 1.2.2. Logical Operators
<a name="block1.2.2.1"></a>
##### 1.2.2.1 AND Comparison Operator
**AND** operations occur implicitly if no logical operators are used in condition chaining

SOQL
```sql
WHERE
    Name = 'Joe Bloggs'
    AND Birthdate = 1970-01-1
```   

QueryBuilder
```apex
  .whereClause(new QueryCondition()
      .equals(Contact.Name, 'Joe Bloggs',
      .equals(Contact.Birthdate, Date.newInstance(1970, 1, 1))
  )
```

<a name="block1.2.2.2"></a>
##### 1.2.2.2 AND Grouped Comparison Operator

SOQL
```sql
WHERE
    Name = 'Joe Bloggs'
    AND (Birthdate = 1970-01-1 AND DoNotCall = False)
```   

QueryBuilder
```apex
  .whereClause(new QueryCondition()
      .equals(Contact.Name, 'Joe Bloggs'
      .andGroup(new QueryCondition()
          .equals(Contact.Birthdate, Date.newInstance(1970, 1, 1))
          .isFalse(Contact.DoNotCall)
      )    
  )
```
<a name="block1.2.2.3"></a>
##### 1.2.2.3 OR Comparison Operator

SOQL
```sql
WHERE
    Name = 'Joe Bloggs'
    OR Name = 'Mary Bloggs'
```   

QueryBuilder
```apex
  .whereClause(new QueryCondition()
      .equals(Contact.Name, 'Joe Bloggs'
      .orCondition(new QueryCondition().equals(Contact.Name, 'Mary Bloggs') 
  )
```

<a name="block1.2.2.4"></a>
##### 1.2.2.4 OR Grouped Comparison Operator

SOQL
```sql
WHERE
    Name = 'Joe Bloggs'
    OR (Name = 'Mary Bloggs' AND DoNotCall = False)
```   

QueryBuilder
```apex
  .whereClause(new QueryCondition()
      .equals(Contact.Name, 'Joe Bloggs'
      .orGroup(new QueryCondition()
          .equals(Contact.Name, 'Mary Bloggs'
          .isFalse(Contact.DoNotCall)
      ) 
  )
```

<a name="block1.3"></a>
## 1.3 Subqueries (parent-to-child) [↑](#index_block)
Child relationship names are implicity determined by the ```ChildRelationship``` class and ```getChildRelationships()``` method on the ```Schema.DescribeFieldResult``` object that's associaated with the ```SObjectType``` that gets passed into the QueryBuilder constructor.

SOQL
```sql
SELECT Id, (SELECT Name FROM Opportunities) 
FROM Account
```

QueryBuilder
```apex
new QueryBuilder(Account.SObjectType)
    .selectField(Account.Id)
    .subQuery(new QueryBuilder(Opportunity.SObjectType)
        .selectField(Opportunity.Name)
    )
.toString();
```

<a name="block2"></a>
## 2. Authors [↑](#index_block)
- Lewis Briffa

<a name="block3"></a>
## 3. License [↑](#index_block)
A Query Builder is licensed under the MIT license.

```
Copyright (c) 2020 Lewis Briffa

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```
