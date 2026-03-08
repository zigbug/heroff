import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import '../blocs/character_creation/character_creation_bloc.dart';

class CharacterNamePhotoStep extends StatefulWidget {
  const CharacterNamePhotoStep({super.key});

  @override
  State<CharacterNamePhotoStep> createState() => _CharacterNamePhotoStepState();
}

class _CharacterNamePhotoStepState extends State<CharacterNamePhotoStep> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<CharacterCreationBloc>();
    _nameController = TextEditingController(
      text: bloc.state.character?.name ?? '',
    );
    _nameController.addListener(() {
      bloc.add(NameChanged(_nameController.text));
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          const Text(
            'Сделай/добавь свою фотку:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height / 3,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.secondary,
                ),
                borderRadius: BorderRadius.circular(8.0),
                color: Theme.of(context).colorScheme.surface,
              ),
              child: BlocBuilder<CharacterCreationBloc, CharacterCreationState>(
                builder: (context, state) {
                  if (state.status == CharacterCreationStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final photoPath = state.character?.photoPath;
                  if (photoPath != null && photoPath.isNotEmpty) {
                    return Image.file(File(photoPath), fit: BoxFit.cover);
                  } else {
                    return const Center(
                      child: Icon(
                        Icons.camera_alt,
                        size: 50,
                        color: Colors.grey,
                      ),
                    );
                  }
                },
              ),
            ),
          ),

          const SizedBox(height: 30),
          const Text(
            'Введите имя персонажа:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'Имя персонажа',
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
