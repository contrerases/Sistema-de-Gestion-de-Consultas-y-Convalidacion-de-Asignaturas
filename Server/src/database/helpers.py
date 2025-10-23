def getTableForeignKey(table: str) -> str:
    return f"id_{table}"


def getTablePrimaryKey(table: str) -> str:
    return f"{table}.id"
