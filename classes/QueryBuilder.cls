/**
 * A class utilising the builder design pattern to abstract the building of queries.
 */
public class QueryBuilder {
	// The fully built SOQL query
	private String query;

	// The fields used in the 'SELECT' clause
	private Set<String> selectedFields;

	// The SObject were applying the query to used in the 'FROM' clause
	private SObjectType entity;

	// The 'WHERE' clause
	private QueryCondition conditionExpression;

	// The 'ORDER BY' clause
	private String orderBy;

	// The 'LIMIT' clause amount
	private Integer limitAmount;

	// The 'OFFSET' clause amount
	private Integer offsetAmount;

	// The chosen sorting direction i.e. ASC/DSC
	private String sortingOption;

	// Sorting options
	public final static String ASCENDING = 'ASC';
	public final static String DESCENDING = 'DSC';

	public QueryBuilder(SObjectType objectType) {
		query = '';
		entity = objectType;
		selectedFields = new Set<String>();
	}

	/**
	 * Adds a field reference to the current selection of applied fields
	 *
	 * @param field		A field reference
	 *
	 * @return			The current instance of the QueryBuilder
	 */
	public QueryBuilder selectField(SObjectField field) {
		selectedFields.add(field.getDescribe().getName());
		return this;
	}

	/**
	 * Adds a list of field references to the current selection of applied fields
	 *
	 * @param fields	A list of field references
	 *
	 * @return			The current instance of the QueryBuilder
	 */
	public QueryBuilder selectFields(List<SObjectField> fields) {
		for(SObjectField field : fields) {
			selectField(field);
		}

		return this;
	}

	/**
	 * Allows cross-object SOQL queries to be constructed on standard relationships
	 *
	 * @param objectType	An object type reference to the relation object
	 * @param field			A field reference from the related object
	 *
	 * @return			The current instance of the QueryBuilder
	 */
	public QueryBuilder selectRelatedField(SObjectType objectType, SObjectField field) {
		selectedFields.add(objectType.getDescribe().getName() + '.' + field.getDescribe().getName());
		return this;
	}

	/**
	 * Allows cross-object SOQL queries to be constructed on custom relationships
	 *
	 * @param lookupField		A field reference to the relation object
	 * @param field				A field reference from the related object
	 *
	 * @return			The current instance of the QueryBuilder
	 */
	public QueryBuilder selectRelatedField(SObjectField lookupField, SObjectField field) {
		String relationshipObjectName = lookupField.getDescribe().getName();
		selectedFields.add(
			relationshipObjectName.substring(0, relationshipObjectName.length() - 1) + 'r.' + field.getDescribe().getName()
		);
		return this;
	}

	@TestVisible
	private SObjectType getEntity() {
		return entity;
	}

	/* -=-=-=-=-=-=-=-=--=-=-=-=-=-=-=-=--=-=-=-=-=-=-
	 * 				Aggregate Functions
	/* -=-=-=-=-=-=-=-=--=-=-=-=-=-=-=-=--=-=-=-=-=-=-
	*/
	public QueryBuilder selectAverageField(SObjectField field) {
		selectedFields.add('AVG(' + field.getDescribe().getName() + ')');
		return this;
	}

	public QueryBuilder selectAverageField(SObjectField field, String alias) {
		selectedFields.add('AVG(' + field.getDescribe().getName() + ') ' + alias);
		return this;
	}

	public QueryBuilder selectCountField(SObjectField field) {
		selectedFields.add('COUNT(' + field.getDescribe().getName() + ')');
		return this;
	}

	public QueryBuilder selectCountField(SObjectField field, String alias) {
		selectedFields.add('COUNT(' + field.getDescribe().getName() + ') ' + alias);
		return this;
	}

	public QueryBuilder selectCountDistinctField(SObjectField field) {
		selectedFields.add('COUNT_DISTINCT(' + field.getDescribe().getName() + ')');
		return this;
	}

	public QueryBuilder selectCountDistinctField(SObjectField field, String alias) {
		selectedFields.add('COUNT_DISTINCT(' + field.getDescribe().getName() + ') ' + alias);
		return this;
	}

	public QueryBuilder selectMinField(SObjectField field) {
		selectedFields.add('MIN(' + field.getDescribe().getName() + ')');
		return this;
	}

	public QueryBuilder selectMinField(SObjectField field, String alias) {
		selectedFields.add('MIN(' + field.getDescribe().getName() + ') ' + alias);
		return this;
	}

	public QueryBuilder selectMaxField(SObjectField field) {
		selectedFields.add('MAX(' + field.getDescribe().getName() + ')');
		return this;
	}

	public QueryBuilder selectMaxField(SObjectField field, String alias) {
		selectedFields.add('MAX(' + field.getDescribe().getName() + ') ' + alias);
		return this;
	}

	public QueryBuilder selectSumField(SObjectField field) {
		selectedFields.add('SUM(' + field.getDescribe().getName() + ')');
		return this;
	}

	public QueryBuilder selectSumField(SObjectField field, String alias) {
		selectedFields.add('SUM(' + field.getDescribe().getName() + ') ' + alias);
		return this;
	}

	public QueryBuilder subQuery(QueryBuilder aQueryBuilder) {
		String subQuery = aQueryBuilder.toString();

		// Find relationship name
		for(ChildRelationship rel : Account.SObjectType.getDescribe().getChildRelationships()) {
			SObjectType entity = aQueryBuilder.getEntity();
			String entityName = entity.getDescribe().getName();
			if (rel.getChildSObject() == aQueryBuilder.getEntity()) {
				subQuery = subQuery.replace('FROM ' + entityName, 'FROM ' + rel.getRelationshipName());
				break;
			}
		}

		selectedFields.add('(' + subQuery + ')');
		return this;
	}

	/**
	 * Builds out the string by concatenating the various clauses together to put together the SOQL query
	 *
	 * @return			A string representation of the SOQL query
	 */
	public override String toString() {
		// 'SELECT' clause
		query = 'SELECT ';
		query += String.join(new List<String>(selectedFields), ', ');

		// 'FROM' clause
		query += ' FROM ' + entity.getDescribe().getName();

		// 'WHERE' clause
		if(conditionExpression != null) {
			query += ' WHERE ' + conditionExpression.toString();
		}

		// 'ORDER BY' clause
		if(orderBy != null) {
			query += ' ORDER BY ' + orderBy;

			// ASC / DSC
			if(sortingOption != null) {
				query += ' ' + sortingOption;
			}
		}

		// 'LIMIT' clause
		if(limitAmount != null) {
			query += ' LIMIT ' + this.limitAmount;
		}

		// 'OFFSET' clause
		if(offsetAmount != null) {
			query += ' OFFSET ' + this.offsetAmount;
		}

		return query;
	}

	/**
	 * Handles the creation of the 'WHERE' clause segment
	 *
	 * @param conditionExpression		A reference to a QueryCondition containing logical statements
	 *
	 * @return		The current instance of the QueryBuilder
	 */
	public QueryBuilder whereClause(QueryCondition conditionExpression) {
		this.conditionExpression = conditionExpression;
		return this;
	}

	/**
	 * Handles the creation of the 'LIMIT' clause segment
	 *
	 * @param limitAmount		The amount of records to return in the query
	 *
	 * @return		The current instance of the QueryBuilder
	 */
	public QueryBuilder take(Integer limitAmount) {
		this.limitAmount = limitAmount;
		return this;
	}

	/**
	 * Handles the creation of the 'OFFSET' clause segment
	 *
	 * @param offsetAmount		The amount of records to skip in the query
	 *
	 * @return		The current instance of the QueryBuilder
	 */
	public QueryBuilder skip(Integer offsetAmount) {
		this.offsetAmount = offsetAmount;
		return this;
	}

	/**
	 * Handles the creation of the 'ORDER BY' clause segment
	 *
	 * @param field			The field reference to order by
	 *
	 * @return		The current instance of the QueryBuilder
	 */
	public QueryBuilder orderBy(SObjectField field) {
		this.orderBy = field.getDescribe().getName();
		return this;
	}

	/**
	 * Handles the creation of the 'ORDER BY' clause segment with an additional sorting option
	 *
	 * @param field				The field reference to order by
	 * @param sortingOption		The direction to order in i.e. ASC/DSC
	 *
	 * @return		The current instance of the QueryBuilder
	 */
	public QueryBuilder orderBy(SObjectField field, String sortingOption) {
		this.orderBy(field);
		this.sortingOption = sortingOption;
		return this;
	}
}