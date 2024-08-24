import 'package:book_store_nodejs/graphql/graphql_config.dart';
import 'package:book_store_nodejs/model/book_model.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLService {
  static GraphQLConfig graphQLConfig = GraphQLConfig();
  GraphQLClient client = graphQLConfig.clientToQuery();

  Future<List<BookModel>> getBooks({required int limit}) async {
    try {
      QueryResult result = await client.query(
        QueryOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql("""
           query GetBooks(\$limit: Int) {
            getBooks(limit: \$limit) {
              _id
              author
              title
              year
              price
            }
          }
      """),
          variables: {"limit": null},
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception);
      }
      List? res = result.data?['getBooks'];

      if (res == null || res.isEmpty) {
        return [];
      }

      List<BookModel> books =
          res.map((book) => BookModel.fromMap(map: book)).toList();

      return books;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> deleteBook({required id}) async {
    try {
      QueryResult result = await client.mutate(
        MutationOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql("""
           mutation Mutation(\$id: ID!) {
            deleteBook(ID: \$id)
          }
      """),
          variables: {"id": id},
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception);
      } else {
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> createBook(
      {required title,
      required  author,
      required int year,
      required int price,
      }) async {
    try {
      QueryResult result = await client.mutate(
        MutationOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql("""
           mutation CreateBook(\$bookInput: BookInput) {
            createBook(bookInput: \$bookInput)
          }
      """),
          variables: {
            "bookInput": {
              "author": author,
              "title": title,
              "year": year,
              "price": price
            }
          },
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception);
      } else {
        return true;
      }
    } catch (e) {
      return false;
    }
  }


  Future<bool> updateBook(
      {required id,
        required title,
        required  author,
        required int year,
        required int price,
      }) async {
    try {
      QueryResult result = await client.mutate(
        MutationOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql("""
           mutation UpdateBook(\$id: ID!, \$bookInput: BookInput) {
            updateBook(ID: \$id, bookInput: \$bookInput)
          }
      """),
          variables: {
            "id": id,
            "bookInput": {
              "author": author,
              "title": title,
              "year": year,
              "price": price
            }
          },
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception);
      } else {
        return true;
      }
    } catch (e) {
      return false;
    }
  }
}
