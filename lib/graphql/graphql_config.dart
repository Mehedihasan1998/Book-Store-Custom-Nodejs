import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLConfig {
  static HttpLink httpLink =
      HttpLink('https://books-demo-apollo-server.onrender.com/');

  GraphQLClient clientToQuery() =>
      GraphQLClient(link: httpLink, cache: GraphQLCache());
}
