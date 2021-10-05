import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


// STEP 1: import sqfentity package.
import 'package:sqfentity_gen/sqfentity_gen.dart';
import 'package:sqfentity/sqfentity.dart';

// STEP 3: Create your Database Model constant instanced from SqfEntityModel
// Note: SqfEntity provides support for the use of multiple databases. So you can create many Database Models and use them in the application.
@SqfEntityBuilder(myDbModel)
const SqfEntityModel myDbModel = SqfEntityModel(
    modelName: null,
    databaseName: 'sampleORM.db',
    // put defined tables into the tables list.
    databaseTables: [tableProject, ],
    // You can define tables to generate add/edit view forms if you want to use Form Generator property
    formTables: [tableProject, ],
    // put defined sequences into the sequences list.
    bundledDatabasePath:
    null // 'assets/sample.db' // This value is optional. When bundledDatabasePath is empty then EntityBase creats a new database when initializing the database
);


// Project テーブル
const SqfEntityTable tableProject = SqfEntityTable(
    tableName: 'project',
    primaryKeyName: 'id',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    useSoftDeleting: true,
    // when useSoftDeleting is true, creates a field named 'isDeleted' on the table, and set to '1' this field when item deleted (does not hard delete)
    modelName: null, // SqfEntity will set it to TableName automatically when the modelName (class name) is null
    // declare fields
    fields: [
      SqfEntityField('name', DbType.text),
      SqfEntityField('isActive', DbType.bool, defaultValue: true),
    ]
);