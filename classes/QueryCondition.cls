public class QueryCondition implements QueryConditionI {
	private Set<String> statements;

	public QueryCondition() {
		statements = new Set<String>();
	}

	/**
	 * Applies the blueprint for condition expressions
	 *
	 * @param field					The SObjectField reference to the field
	 * @param comparisonOperator	The comparison operator being used e.g. = != > <=
	 * @param value					The value to compare against
	 */
	private void addStatement(SObjectField field, String comparisonOperator, Object value) {
		if(value instanceof String) {
			value = '\'' + value + '\'';
		} else if(value instanceof Date) {
			value = String.valueOf((Date) value);
		}

		this.statements.add(String.format('{0} {1} {2}', new List<Object>{ field, comparisonOperator, value }));
	}

	/**
	 * Handles the creation of the '=' comparison operator
	 *
	 * @param field		A field reference to apply the operator to
	 * @param value		The string value to search against
	 *
	 * @return			The current instance of the QueryBuilder
	 */
	public QueryCondition equals(SObjectField field, String value) {
		addStatement(field, '=', value);
		return this;
	}

	/**
	 * Handles the creation of the '=' comparison operator on a given date
	 *
	 * @param field		A field reference to apply the operator to
	 * @param aDate		The date value to search against
	 *
	 * @return			The current instance of the QueryBuilder
	 */
	public QueryCondition equals(SObjectField field, Date aDate) {
		addStatement(field, '=', aDate);
		return this;
	}

	/**
	 * Handles the creation of the '!=' comparison operator
	 *
	 * @param field		A field reference to apply the operator to
	 * @param value		The string value to search against
	 *
	 * @return			The current instance of the QueryBuilder
	 */
	public QueryCondition notEquals(SObjectField field, String value) {
		addStatement(field, '!=', value);
		return this;
	}

	/**
	 * Handles the creation of the '!=' comparison operator on a given date
	 *
	 * @param field		A field reference to apply the operator to
	 * @param aDate		The date value to search against
	 *
	 * @return			The current instance of the QueryBuilder
	 */
	public QueryCondition notEquals(SObjectField field, Date aDate) {
		addStatement(field, '!=', aDate);
		return this;
	}

	/**
	 * Handles the creation of the '=' comparison operator that checks for TRUE values
	 *
	 * @param field		A field reference to apply the operator to
	 *
	 * @return			The current instance of the QueryBuilder
	 */
	public QueryCondition isTrue(SObjectField field) {
		addStatement(field, '=', true);
		return this;
	}

	/**
	 * Handles the creation of the '=' comparison operator that checks for FALSE values
	 *
	 * @param field		A field reference to apply the operator to
	 *
	 * @return			The current instance of the QueryBuilder
	 */
	public QueryCondition isFalse(SObjectField field) {
		addStatement(field, '=', false);
		return this;
	}

	/**
	 * Handles the creation of the '=' comparison operator that checks for NULL values
	 *
	 * @param field		A field reference to apply the operator to
	 *
	 * @return			The current instance of the QueryBuilder
	 */
	public QueryCondition isNull(SObjectField field) {
		this.statements.add(field + ' = ' + null);
		return this;
	}

	/**
	 * Handles the creation of the '!=' comparison operator that checks for NULL values
	 *
	 * @param field		A field reference to apply the operator to
	 *
	 * @return			The current instance of the QueryBuilder
	 */
	public QueryCondition isNotNull(SObjectField field) {
		this.statements.add(field + ' != ' + null);
		return this;
	}

	/**
	 * Handles the creation of the '>' comparison operator
	 *
	 * @param field		A field reference to apply the operator to
	 * @param value		The value to compare against
	 *
	 * @return			The current instance of the QueryBuilder
	 */
	public QueryCondition greaterThan(SObjectField field, Integer value) {
		addStatement(field, '>', value);
		return this;
	}

	/**
	 * Handles the creation of the '>' comparison operator on a given date
	 *
	 * @param field		A field reference to apply the operator to
	 * @param aDate		The date value to compare against
	 *
	 * @return			The current instance of the QueryBuilder
	 */
	public QueryCondition greaterThan(SObjectField field, Date aDate) {
		addStatement(field, '>', aDate);
		return this;
	}

	/**
	 * Handles the creation of the '>=' comparison operator
	 *
	 * @param field		A field reference to apply the operator to
	 * @param value		The value to compare against
	 *
	 * @return			The current instance of the QueryBuilder
	 */
	public QueryCondition greaterThanAndEqualTo(SObjectField field, Integer value) {
		addStatement(field, '>=', value);
		return this;
	}

	/**
	 * Handles the creation of the '>=' comparison operator on a given date
	 *
	 * @param field		A field reference to apply the operator to
	 * @param aDate		The date value to compare against
	 *
	 * @return			The current instance of the QueryBuilder
	 */
	public QueryCondition greaterThanAndEqualTo(SObjectField field, Date aDate) {
		addStatement(field, '>=', aDate);
		return this;
	}

	/**
	 * Handles the creation of the '<' comparison operator
	 *
	 * @param field		A field reference to apply the operator to
	 * @param value		The value to compare against
	 *
	 * @return			The current instance of the QueryBuilder
	 */
	public QueryCondition lessThan(SObjectField field, Integer value) {
		addStatement(field, '<', value);
		return this;
	}

	/**
	 * Handles the creation of the '<' comparison operator on a given date
	 *
	 * @param field		A field reference to apply the operator to
	 * @param aDate		The date value to compare against
	 *
	 * @return			The current instance of the QueryBuilder
	 */
	public QueryCondition lessThan(SObjectField field, Date aDate) {
		addStatement(field, '<', aDate);
		return this;
	}

	/**
	 * Handles the creation of the '<=' comparison operator
	 *
	 * @param field		A field reference to apply the operator to
	 * @param value		The value to compare against
	 *
	 * @return			The current instance of the QueryBuilder
	 */
	public QueryCondition lessThanAndEqualTo(SObjectField field, Integer value) {
		addStatement(field, '<=', value);
		return this;
	}

	/**
	 * Handles the creation of the '<=' comparison operator on a given date
	 *
	 * @param field		A field reference to apply the operator to
	 * @param aDate		The date value to compare against
	 *
	 * @return			The current instance of the QueryBuilder
	 */
	public QueryCondition lessThanAndEqualTo(SObjectField field, Date aDate) {
		addStatement(field, '<=', aDate);
		return this;
	}

	/**
	 * Handles the creation of the '=' comparison operator that checks for date values that match TODAY
	 *
	 * @param field		A field reference to apply the operator to
	 *
	 * @return			The current instance of the QueryBuilder
	 */
	public QueryCondition isToday(SObjectField field) {
		addStatement(field, '=', Date.today());
		return this;
	}

	/**
	 * Handles the creation of the 'LIKE' comparison operator
	 *
	 * @param field		A field reference to apply the operator to
	 * @param value		The string pattern to search against
	 *
	 * @return			The current instance of the QueryBuilder
	 */
	public QueryCondition isLike(SObjectField field, String value) {
		addStatement(field, 'LIKE', value);
		return this;
	}

	/**
	 * Handles the creation of the 'IN' comparison operator against a given value
	 *
	 * @param field			A field reference to apply the operator to
	 * @param value			The value to check against
	 *
	 * @return		The current instance of the QueryBuilder
	 */
	public QueryCondition isIn(SObjectField field, Object value) {
		addStatement(field, 'IN', '(\'' + String.valueOf(value) + '\')');
		return this;
	}

	/**
	 * Handles the creation of the 'IN' comparison operator for a list of values
	 *
	 * @param field			A field reference to apply the operator to
	 * @param values		A list of object values representing the values to check against
	 *
	 * @return		The current instance of the QueryBuilder
	 */
	public QueryCondition isIn(SObjectField field, List<Object> values) {
		List<String> valuesStr = new List<String>();

		for(Integer i = 0; i < values.size(); i++) {
			valuesStr.add('\'' + String.valueOf(values[i]) + '\'');
		}

		addStatement(field, 'IN', valuesStr);
		return this;
	}

	/**
	 * Handles the creation of the 'IN' comparison operator for a set of values
	 *
	 * @param field			A field reference to apply the operator to
	 * @param values		A set of string values representing the values to check against
	 *
	 * @return		The current instance of the QueryBuilder
	 */
	public QueryCondition isIn(SObjectField field, Set<String> values) {
		isIn(field, new List<String>(values));
		return this;
	}

	/**
	 * Handles the creation of the 'IN' comparison operator for a set of values
	 *
	 * @param field			A field reference to apply the operator to
	 * @param values		A set of id values representing the values to check against
	 *
	 * @return		The current instance of the QueryBuilder
	 */
	public QueryCondition isIn(SObjectField field, Set<Id> values) {
		isIn(field, new List<Id>(values));
		return this;
	}

	/**
	 * Handles the creation of the 'NOT IN' comparison operator against a given value
	 *
	 * @param field			A field reference to apply the operator to
	 * @param value			The value to check against
	 *
	 * @return		The current instance of the QueryBuilder
	 */
	public QueryCondition isNotIn(SObjectField field, Object value) {
		addStatement(field, 'NOT IN', '(\'' + String.valueOf(value) + '\')');
		return this;
	}

	/**
	 * Handles the creation of the 'NOT IN' comparison operator for a list of values
	 *
	 * @param field			A field reference to apply the operator to
	 * @param values		A list of object values representing the values to check against
	 *
	 * @return		The current instance of the QueryBuilder
	 */
	public QueryCondition isNotIn(SObjectField field, List<Object> values) {
		List<String> valuesStr = new List<String>();

		for(Integer i = 0; i < values.size(); i++) {
			valuesStr.add('\'' + String.valueOf(values[i]) + '\'');
		}

		addStatement(field, 'NOT IN', valuesStr);
		return this;
	}

	/**
	 * Handles the creation of the 'NOT IN' comparison operator for a set of values
	 *
	 * @param field			A field reference to apply the operator to
	 * @param values		A set of id values representing the values to check against
	 *
	 * @return		The current instance of the QueryBuilder
	 */
	public QueryCondition isNotIn(SObjectField field, Set<Id> values) {
		isNotIn(field, new List<Id>(values));
		return this;
	}

	/**
	 * Handles the creation of the 'NOT IN' comparison operator for a set of values
	 *
	 * @param field			A field reference to apply the operator to
	 * @param values		A set of string values representing the values to check against
	 *
	 * @return		The current instance of the QueryBuilder
	 */
	public QueryCondition isNotIn(SObjectField field, Set<String> values) {
		isNotIn(field, new List<String>(values));
		return this;
	}

	/**
	 * Handles the creation of the 'INCLUDES' comparison operator against a given value
	 *
	 * @param field			A field reference to apply the operator to
	 * @param value			The value to check against
	 *
	 * @return		The current instance of the QueryBuilder
	 */
	public QueryCondition including(SObjectField field, Object value) {
		addStatement(field, 'INCLUDES', '(\'' + String.valueOf(value) + '\')');
		return this;
	}

	/**
	 * Handles the creation of the 'INCLUDES' comparison operator for a list of values
	 *
	 * @param field			A field reference to apply the operator to
	 * @param values		A list of string values representing the values to check against
	 *
	 * @return		The current instance of the QueryBuilder
	 */
	public QueryCondition including(SObjectField field, List<String> values) {
		List<String> valuesStr = new List<String>();

		for(Integer i = 0; i < values.size(); i++) {
			valuesStr.add('\'' + String.valueOf(values[i]) + '\'');
		}

		addStatement(field, 'INCLUDES', valuesStr);
		return this;
	}

	/**
	 * Handles the creation of the 'EXCLUDES' comparison operator against a given value
	 *
	 * @param field			A field reference to apply the operator to
	 * @param value			The value to check against
	 *
	 * @return		The current instance of the QueryBuilder
	 */
	public QueryCondition excluding(SObjectField field, Object value) {
		addStatement(field, 'EXCLUDES', '(\'' + String.valueOf(value) + '\')');
		return this;
	}

	/**
	 * Handles the creation of the 'EXCLUDES' comparison operator for a list of values
	 *
	 * @param field			A field reference to apply the operator to
	 * @param values		A list of string values representing the values to check against
	 *
	 * @return		The current instance of the QueryBuilder
	 */
	public QueryCondition excluding(SObjectField field, List<String> values) {
		List<String> valuesStr = new List<String>();

		for(Integer i = 0; i < values.size(); i++) {
			valuesStr.add('\'' + String.valueOf(values[i]) + '\'');
		}

		addStatement(field, 'EXCLUDES', valuesStr);
		return this;
	}

	/**
	 * Handles the creation of the 'AND' logical operator
	 *
	 * @param condition		A reference to a QueryCondition supplying the expression
	 *
	 * @return				The current instance of the QueryBuilder
	 */
	public QueryCondition andCondition(QueryCondition condition) {
		this.statements.add(' AND ' + condition.toString());
		return this;
	}

	/**
	 * Handles the creation of the 'AND' logical operator whose expression is grouped in parentheses
	 *
	 * @param condition		A reference to a QueryCondition supplying the expression
	 *
	 * @return				The current instance of the QueryBuilder
	 */
	public QueryCondition andGroup(QueryCondition condition) {
		this.statements.add(' AND (' + condition.toString() + ')');
		return this;
	}

	/**
	 * Handles the creation of the 'OR' logical operator
	 *
	 * @param condition		A reference to a QueryCondition supplying the expression
	 *
	 * @return				The current instance of the QueryBuilder
	 */
	public QueryCondition orCondition(QueryCondition condition) {
		this.statements.add(' OR ' + condition.toString());
		return this;
	}

	/**
	 * Handles the creation of the 'OR' logical operator whose expression is grouped in parentheses
	 *
	 * @param condition		A reference to a QueryCondition supplying the expression
	 *
	 * @return				The current instance of the QueryBuilder
	 */
	public QueryCondition orGroup(QueryCondition condition) {
		this.statements.add(' OR (' + condition.toString() + ')');
		return this;
	}

	/**
	 * Groups a QueryCondition expression in parentheses
	 *
	 * @param condition		A reference to a QueryCondition supplying the expression
	 *
	 * @return				The current instance of the QueryBuilder
	 */
	public QueryCondition group(QueryCondition condition) {
		this.statements.add('(' + condition.toString() + ')');
		return this;
	}

	/**
	 * Builds out the string by concatenating the various statements together to create the condition segment
	 *
	 * @return		A string representation of the condition portion
	 */
	public override String toString() {
		List<String> statements = new List<String>(statements);

		for(Integer i = 0; i < statements.size(); i++) {
			// Allow comparison operator chaining without explicit 'AND' condition groupings
			if(i != 0) {
				// If this QueryCondition doesn't already contain a logical operator prefix automatically assume 'AND'
				if(!statements[i].startsWith(' AND') && !statements[i].startsWith(' OR')) {
					statements[i] = ' AND ' + statements[i];
				}
			}
		}

		return String.join(statements, '');
	}

	/**
	 * Interface defining the expected methods to be implemented by any object looking to implement SOQL
	 * query 'WHERE' condition logic
	 */
	interface QueryConditionI {
		// Comparison Operators
		Object equals(SObjectField field, String value);						// = 'value'
		Object equals(SObjectField field, Date aDate);							// = 2020-07-03
		Object notEquals(SObjectField field, Date aDate);						// != 2020-07-03
		Object notEquals(SObjectField field, String value);						// != 'value'
		Object greaterThan(SObjectField field, Integer value);					// > 100
		Object greaterThan(SObjectField field, Date aDate);						// > 2020-07-03
		Object greaterThanAndEqualTo(SObjectField field, Integer value);		// >= 100
		Object greaterThanAndEqualTo(SObjectField field, Date aDate);			// >= 2020-07-03
		Object lessThan(SObjectField field, Integer value);						// < 100
		Object lessThan(SObjectField field, Date aDate);						// < 2020-07-03
		Object lessThanAndEqualTo(SObjectField field, Integer value);			// <= 100
		Object lessThanAndEqualTo(SObjectField field, Date aDate);				// <= 2020-07-03
		Object isTrue(SObjectField field);										// = TRUE
		Object isFalse(SObjectField field);										// = FALSE
		Object isNull(SObjectField field);										// = null
		Object isNotNull(SObjectField field);									// != null
		Object isToday(SObjectField field);										// = TODAY
		Object isLike(SObjectField field, String value);						// LIKE '%value%'
		Object isIn(SObjectField field, Object value);							// IN ('Closed Won')
		Object isIn(SObjectField field, List<Object> values);					// IN ('Closed Won', 'Closed Lost')
		Object isIn(SObjectField field, Set<String> values);					// IN ('Closed Won', 'Closed Lost')
		Object isIn(SObjectField field, Set<Id> values);						// IN ('0060q00000GqOQU', '0060q00000GqOOl')
		Object isNotIn(SObjectField field, Object value);						// NOT IN ('Closed Won')
		Object isNotIn(SObjectField field, List<Object> values);				// NOT IN ('Closed Won', 'Closed Lost')
		Object isNotIn(SObjectField field, Set<String> values);					// NOT IN ('Closed Won', 'Closed Lost')
		Object isNotIn(SObjectField field, Set<Id> values);						// NOT IN ('0060q00000GqOQU', '0060q00000GqOOl')

		// Logical Operators
		Object andCondition(QueryCondition condition);							// AND ...
		Object andGroup(QueryCondition condition);								// AND (...)
		Object orCondition(QueryCondition condition);							// OR ...
		Object orGroup(QueryCondition condition);								// OR (...)
		Object group(QueryCondition condition);									// (...)
	}
}