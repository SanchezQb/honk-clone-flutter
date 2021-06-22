import 'package:flutter/material.dart';
import 'dart:async';
import 'package:honk_clone/ui/auth/models/user_model.dart';
import 'package:honk_clone/ui/search/providers/search_state.dart';
import 'package:honk_clone/ui/search/providers/search_state_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Timer? searchTimer;

  _onChangeHandler(value) {
    const duration = Duration(milliseconds: 800);
    if (searchTimer != null) {
      setState(() => searchTimer!.cancel()); // clear timer
    }
    setState(
      () => searchTimer = new Timer(
        duration,
        () {
          context
              .read(searchStateNotifier.notifier)
              .searchForUsers(query: value);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: TextField(
          onChanged: _onChangeHandler,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(10.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            hintText: "Search for users",
            filled: true,
            fillColor: Theme.of(context).cardColor,
            prefixIcon: const Icon(
              Icons.search,
            ),
          ),
        ),
      ),
      body: ProviderListener(
        onChange: (context, dynamic state) {
          if (state is SearchErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                  state.message!,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            );
          }
        },
        provider: searchStateNotifier,
        child: Consumer(builder: (context, watch, _) {
          final state = watch(searchStateNotifier);
          if (state is SearchLoadingState) {
            return Container();
          }
          if (state is SearchInitialState) {
            return Center(child: Text("Search for users"));
          }
          if (state is SearchLoadedState) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: state.results.length,
                itemBuilder: (BuildContext context, int index) {
                  final User user = state.results[index];

                  return ListTile(
                    onTap: () {},
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      child: Text(user.name![0]),
                      backgroundColor: Theme.of(context).cardColor,
                      radius: 30,
                    ),
                    title: Text(
                      user.name!,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    subtitle: Text("@${user.username}"),
                  );
                },
              ),
            );
          } else {
            return Container();
          }
        }),
      ),
    );
  }
}
