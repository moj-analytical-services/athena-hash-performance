{% macro deduplicate(relation,
                     partition_by,
                     order_by=None,
                     where_condition=None,
                     CTE_columns=None
                    ) %}

    {% if CTE_columns is none %}
        {% set all_cols = dbt_utils.star(from=relation) %}
    {% else  %}
        {% set all_cols = CTE_columns %}    
    {% endif %}

    SELECT {{ all_cols }} FROM (
        SELECT
        *,
        ROW_NUMBER() OVER(PARTITION BY {{ ','.join(partition_by) }}
            {% if order_by is not none %}
                ORDER BY {{','.join(order_by)}}
            {% endif %}
        ) AS row
        FROM {{ relation }}
        {% if where_condition is not none %}
            WHERE {{ where_condition }}
        {% endif %}
    )
    WHERE row = 1

{% endmacro %}