/// Table and data grid components for the TKit design system
///
/// This library provides components for displaying tabular data with
/// features like sorting, selection, and pagination.
///
/// Example usage:
/// ```dart
/// import 'package:tkit_flutter/shared/widgets/tables/tables.dart';
///
/// TKitDataTable<User>(
///   items: users,
///   columns: [
///     TKitTableColumn(
///       label: 'Name',
///       id: 'name',
///       cellBuilder: (user) => Text(user.name),
///       sortable: true,
///       comparator: (a, b) => a.name.compareTo(b.name),
///     ),
///     TKitTableColumn(
///       label: 'Email',
///       id: 'email',
///       cellBuilder: (user) => Text(user.email),
///     ),
///   ],
///   onRowTap: (user) => print('Tapped: ${user.name}'),
/// );
///
/// Pagination(
///   currentPage: 1,
///   totalPages: 10,
///   onPageChanged: (page) => print('Go to page $page'),
/// );
/// ```
library;

export 'data_table.dart';
export 'pagination.dart';
