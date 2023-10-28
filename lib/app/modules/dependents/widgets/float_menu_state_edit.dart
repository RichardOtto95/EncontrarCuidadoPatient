import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../shared/utilities.dart';
import '../dependents_store.dart';

class StatesFieldEdit extends StatefulWidget {
  const StatesFieldEdit({
    Key key,
  }) : super(key: key);
  @override
  _StatesFieldEditState createState() => _StatesFieldEditState();
}

class _StatesFieldEditState extends State<StatesFieldEdit> {
  final DependentsStore store = Modular.get();
  OverlayEntry _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    store.getStates();
    store.focusNodeStateEdit = FocusNode();
    store.textEditingControllerStateEdit.text =
        store.mapDependentUpdate['state'] != null
            ? store.mapDependentUpdate['state']
            : '';
    store.focusNodeStateEdit.addListener(() {
      if (store.focusNodeStateEdit.hasFocus) {
        store.inputEdit = true && store.newListStates.isNotEmpty;
        _overlayEntry = _createOverlayEntry();
        Overlay.of(context).insert(_overlayEntry);
      } else {
        store.inputEdit = false;
        _overlayEntry.remove();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_overlayEntry != null && _overlayEntry.mounted) {
      _overlayEntry.remove();
    }

    store.focusNodeStateEdit.removeListener(() {});
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;

    return OverlayEntry(
        builder: (context) => Positioned(
              width: wXD(291, context),
              child: CompositedTransformFollower(
                  offset: Offset(0, size.height),
                  link: _layerLink,
                  child: Material(
                      color: Colors.transparent,
                      child: FloatMenuState(
                        onTap: () {
                          store.filterListCity(store
                              .textEditingControllerCityEdit.text
                              .toLowerCase());
                          store.focusNodeStateEdit.unfocus();
                          store.focusNodeCityEdit.requestFocus();
                        },
                      ))),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return CompositedTransformTarget(
          link: _layerLink,
          child: Container(
            alignment: Alignment.bottomLeft,
            width: wXD(250, context),
            child: TextFormField(
              onTap: () {
                store.filterListState(
                    store.textEditingControllerStateEdit.text.toLowerCase());
              },
              focusNode: store.focusNodeStateEdit,
              controller: store.textEditingControllerStateEdit,
              autocorrect: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textCapitalization: TextCapitalization.sentences,
              onEditingComplete: () {
                store.filterListCity(
                    store.textEditingControllerCityEdit.text.toLowerCase());
                store.focusNodeStateEdit.unfocus();
                store.focusNodeCityEdit.requestFocus();
              },
              validator: (value) {
                if (store.mapDependentUpdate['state'] !=
                    store.textEditingControllerStateEdit.text) {
                  return 'Selecione um estado';
                } else if (value.isEmpty) {
                  return 'Este campo não pode ser vazio';
                } else {
                  return null;
                }
              },
              cursorColor: Color(0xff707070),
              style: TextStyle(
                  fontSize: wXD(17, context),
                  fontWeight: FontWeight.w400,
                  color: Color(0xff707070)),
              decoration: InputDecoration.collapsed(
                hintText: 'Ex: Distrito Federal',
                hintStyle: TextStyle(
                  fontSize: wXD(17, context),
                  fontWeight: FontWeight.w400,
                  color: Color(0x30707070),
                ),
              ),
              onChanged: (value) {
                store.filterListState(value.toLowerCase());
                store.inputEdit = true && store.newListStates.isNotEmpty;
              },
            ),
          ),
        );
        // );
      },
    );
  }
}

class FloatMenuState extends StatelessWidget {
  final DependentsStore store = Modular.get();
  final Function onTap;
  FloatMenuState({
    Key key,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                blurRadius: 6,
                offset: Offset(0, 3),
                color: Color(0x30000000),
              )
            ]),
        child: Container(
          height: store.newListStates.length > 6
              ? wXD(150, context)
              : store.newListStates.length * wXD(25, context),
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(
                store.newListStates.length,
                (index) => FloatMenuButton(
                  title: store.newListStates[index],
                  onTap: () async {
                    int count = store.newListStates[index].length;

                    String name =
                        store.newListStates[index].substring(0, count - 5);

                    store.mapDependentUpdate['state'] = name;

                    store.textEditingControllerStateEdit.clear();

                    store.textEditingControllerStateEdit.text = name;

                    await store.getCitys(true);
                    onTap();
                  },
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

class FloatMenuButton extends StatelessWidget {
  final String title;
  final Function onTap;
  const FloatMenuButton({
    Key key,
    this.title,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: wXD(25, context),
        padding: EdgeInsets.only(left: wXD(14, context)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: wXD(16, context),
                color: Color(0xfa707070),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
