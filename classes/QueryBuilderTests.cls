@IsTest
public class QueryBuilderTests {
	private static Boolean isValid = true;

	@IsTest
	public static void testCustomObject() {

	}

	@IsTest
	public static void testEntityName() {
		SObjectType entity = new QueryBuilder(Contact.SObjectType)
			.selectField(Contact.Id)
			.getEntity();

		System.assertEquals(Contact.SObjectType, entity);
	}

	@IsTest
	public static void testBasicQuery() {
		String query = new QueryBuilder(Opportunity.SObjectType)
			.selectFields(new SObjectField[] {
				Opportunity.Id,
				Opportunity.Name,
				Opportunity.CloseDate,
				Opportunity.StageName
			})
		.toString();

		Test.startTest();
		new SOQLTester().tryQuery(query);
		Test.stopTest();

		System.assertEquals('SELECT Id, Name, CloseDate, StageName FROM Opportunity', query);
	}

	@IsTest
	public static void testWhereClauseQuery() {
		String query = new QueryBuilder(Opportunity.SObjectType)
			.selectFields(new SObjectField[] {
				Opportunity.Id,
				Opportunity.Name,
				Opportunity.CloseDate,
				Opportunity.StageName
			})
			.whereClause(new QueryCondition()
				.isFalse(Opportunity.IsPrivate)
			)
			.toString();

		Test.startTest();
		new SOQLTester().tryQuery(query);
		Test.stopTest();

		System.assertEquals('SELECT Id, Name, CloseDate, StageName FROM Opportunity WHERE IsPrivate = false', query);
	}

	@IsTest
	public static void testNotEqualToQuery() {
		String query = new QueryBuilder(Opportunity.SObjectType)
			.selectFields(new SObjectField[] {
				Opportunity.Id,
				Opportunity.Name,
				Opportunity.CloseDate,
				Opportunity.StageName
			})
			.whereClause(new QueryCondition()
				.isNotNull(Opportunity.NextStep)
			)
			.toString();

		Test.startTest();
		new SOQLTester().tryQuery(query);
		Test.stopTest();

		System.assertEquals('SELECT Id, Name, CloseDate, StageName FROM Opportunity WHERE NextStep != null', query);
	}

	@IsTest
	public static void testBasicAndQuery() {
		String query = new QueryBuilder(Opportunity.SObjectType)
			.selectFields(new SObjectField[] {
				Opportunity.Id,
				Opportunity.Name,
				Opportunity.CloseDate,
				Opportunity.StageName
			})
			.whereClause(new QueryCondition()
				.isNotNull(Opportunity.NextStep)
				.isFalse(Opportunity.IsPrivate)
			)
			.toString();

		Test.startTest();
		new SOQLTester().tryQuery(query);
		Test.stopTest();

		System.assertEquals('SELECT Id, Name, CloseDate, StageName FROM Opportunity WHERE NextStep != null AND IsPrivate = false', query);
	}

	@IsTest
	public static void testAndGroupedOrQuery() {
		String query = new QueryBuilder(Opportunity.SObjectType)
			.selectFields(new SObjectField[] {
				Opportunity.Id,
				Opportunity.Name,
				Opportunity.CloseDate,
				Opportunity.StageName
			})
			.whereClause(new QueryCondition()
				.group(new QueryCondition()
					.isNotNull(Opportunity.NextStep)
					.isFalse(Opportunity.IsPrivate)
				)
				.orCondition(new QueryCondition().isNotNull(Opportunity.ForecastCategoryName))
			)
			.toString();

		Test.startTest();
		new SOQLTester().tryQuery(query);
		Test.stopTest();

		System.assertEquals('SELECT Id, Name, CloseDate, StageName FROM Opportunity WHERE (NextStep != null AND IsPrivate = false) OR ForecastCategoryName != null', query);
	}

	@IsTest
	public static void testBasicStringQuery() {
		String query = new QueryBuilder(Opportunity.SObjectType)
			.selectFields(new SObjectField[] {
				Opportunity.Id,
				Opportunity.Name,
				Opportunity.CloseDate,
				Opportunity.StageName
			})
			.whereClause(new QueryCondition()
				.isNotNull(Opportunity.NextStep)
				.equals(Opportunity.StageName, 'Closed Won')
			)
			.toString();

		Test.startTest();
		new SOQLTester().tryQuery(query);
		Test.stopTest();

		System.assertEquals('SELECT Id, Name, CloseDate, StageName FROM Opportunity WHERE NextStep != null AND StageName = \'Closed Won\'', query);
	}

	@IsTest
	public static void testBasicNumberQuery() {
		String query = new QueryBuilder(Opportunity.SObjectType)
			.selectFields(new SObjectField[] {
				Opportunity.Id,
				Opportunity.Name,
				Opportunity.CloseDate,
				Opportunity.StageName
			})
			.whereClause(new QueryCondition()
				.isNotNull(Opportunity.NextStep)
				.equals(Opportunity.StageName, 'Closed Won')
				.greaterThan(Opportunity.Amount, 100)
			)
			.toString();

		Test.startTest();
		new SOQLTester().tryQuery(query);
		Test.stopTest();

		System.assertEquals('SELECT Id, Name, CloseDate, StageName FROM Opportunity WHERE NextStep != null AND StageName = \'Closed Won\' AND Amount > 100', query);
	}

	@IsTest
	public static void testTodayQuery() {
		String query = new QueryBuilder(Opportunity.SObjectType)
			.selectFields(new SObjectField[] {
				Opportunity.Id,
				Opportunity.Name,
				Opportunity.CloseDate,
				Opportunity.StageName
			})
			.whereClause(new QueryCondition()
				.isNotNull(Opportunity.NextStep)
				.equals(Opportunity.CloseDate, Date.today())
			)
			.toString();

		Test.startTest();
		new SOQLTester().tryQuery(query);
		Test.stopTest();

		Date today = Date.today();
		System.assertEquals('SELECT Id, Name, CloseDate, StageName FROM Opportunity WHERE NextStep != null AND CloseDate = ' + String.valueOf(today), query);
	}

	@IsTest
	public static void testFuzzyMatchingQuery() {
		String query = new QueryBuilder(Opportunity.SObjectType)
			.selectFields(new SObjectField[] {
				Opportunity.Id,
				Opportunity.Name,
				Opportunity.CloseDate,
				Opportunity.StageName
			})
			.whereClause(new QueryCondition()
				.equals(Opportunity.StageName, 'Closed Won')
				.isLike(Opportunity.Name, '%(IT)%')
			)
			.toString();

		Test.startTest();
		new SOQLTester().tryQuery(query);
		Test.stopTest();

		System.assertEquals('SELECT Id, Name, CloseDate, StageName FROM Opportunity WHERE StageName = \'Closed Won\' AND Name LIKE \'%(IT)%\'', query);
	}

	@IsTest
	public static void testSortAscending() {
		String query = new QueryBuilder(Opportunity.SObjectType)
			.selectFields(new SObjectField[] {
				Opportunity.Id,
				Opportunity.Name,
				Opportunity.CloseDate,
				Opportunity.StageName
			})
			.whereClause(new QueryCondition()
				.isNotNull(Opportunity.NextStep)
			)
			.orderBy(Opportunity.Name, QueryBuilder.ASCENDING)
			.toString();

		Test.startTest();
		new SOQLTester().tryQuery(query);
		Test.stopTest();

		System.assertEquals('SELECT Id, Name, CloseDate, StageName FROM Opportunity WHERE NextStep != null ORDER BY Name ASC', query);
	}

	@IsTest
	public static void testLimitQuery() {
		String query = new QueryBuilder(Opportunity.SObjectType)
			.selectFields(new SObjectField[] {
				Opportunity.Id,
				Opportunity.Name,
				Opportunity.CloseDate,
				Opportunity.StageName
			})
			.whereClause(new QueryCondition()
				.isNotNull(Opportunity.NextStep)
			)
			.take(5)
			.toString();

		Test.startTest();
		new SOQLTester().tryQuery(query);
		Test.stopTest();

		System.assertEquals('SELECT Id, Name, CloseDate, StageName FROM Opportunity WHERE NextStep != null LIMIT 5', query);
	}

	@IsTest
	public static void basicSelectAggregateFunctions() {
		String query = new QueryBuilder(Opportunity.SObjectType)
			.selectAverageField(Opportunity.Amount)
			.selectMinField(Opportunity.Amount)
			.selectMaxField(Opportunity.Amount)
			.selectSumField(Opportunity.Amount)
			.selectCountField(Opportunity.Id)
			.selectCountDistinctField(Opportunity.Type)
			.toString();

		Test.startTest();
		new SOQLTester().tryQuery(query);
		Test.stopTest();

		System.assertEquals('SELECT AVG(Amount), MIN(Amount), MAX(Amount), SUM(Amount), COUNT(Id), COUNT_DISTINCT(Type) FROM Opportunity', query);
	}

	@IsTest
	public static void basicSelectAggregateFunctionsWithAlias() {
		String query = new QueryBuilder(Opportunity.SObjectType)
			.selectAverageField(Opportunity.Amount, 'Average_Amount')
			.selectMinField(Opportunity.Amount, 'Min_Amount')
			.selectMaxField(Opportunity.Amount, 'Max_Amount')
			.selectSumField(Opportunity.Amount, 'Total_Amount')
			.selectCountField(Opportunity.Id, 'Id_Count')
			.selectCountDistinctField(Opportunity.Type, 'Unique_Type_Count')
			.toString();


		System.debug(query);


		Test.startTest();
		new SOQLTester().tryQuery(query);
		Test.stopTest();

		System.assertEquals('SELECT AVG(Amount) Average_Amount, MIN(Amount) Min_Amount, MAX(Amount) Max_Amount, SUM(Amount) Total_Amount, COUNT(Id) Id_Count, COUNT_DISTINCT(Type) Unique_Type_Count FROM Opportunity', query);
	}

	@IsTest
	public static void testComplexSingleObjectQuery() {
		String query = new QueryBuilder(Opportunity.SObjectType)
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
			.orderBy(Opportunity.Name, QueryBuilder.ASCENDING)
			.take(5)
			.skip(3)
		.toString();

		Test.startTest();
		new SOQLTester().tryQuery(query);
		Test.stopTest();

		Date today = Date.today();
		System.assertEquals('SELECT Id, Name, CloseDate, StageName FROM Opportunity WHERE CloseDate = ' + String.valueOf(today) + ' AND StageName = \'Closed Won\' AND Amount > 100 AND ((NextStep != null AND IsPrivate = false AND Name LIKE \'%(IT)%\') OR Type != null) ORDER BY Name ASC LIMIT 5 OFFSET 3', query);
	}

	@IsTest
	public static void testSubQuery() {
		String query = new QueryBuilder(Account.SObjectType)
			.selectField(Account.Id)
			.subQuery(new QueryBuilder(Opportunity.SObjectType)
				.selectField(Opportunity.Name)
			)
		.toString();

		Test.startTest();
		new SOQLTester().tryQuery(query);
		Test.stopTest();

		System.assertEquals('SELECT Id, (SELECT Name FROM Opportunities) FROM Account', query);
	}

	public class SOQLTester {
		private void tryQuery(String query) {
			try {
				Database.query(query);
			} catch (QueryException ex) {
				isValid = false;
			}

			System.assertEquals(true, isValid);
		}
	}
}