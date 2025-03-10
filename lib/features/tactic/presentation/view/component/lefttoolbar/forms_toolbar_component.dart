
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/forms/form_component.dart';
import 'package:zporter_board/features/tactic/data/model/form_data_model.dart';
import 'package:zporter_board/features/tactic/presentation/view/component/forms/form_utils.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/form/form_bloc.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/form/form_event.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/form/form_state.dart' as fs;

class FormsToolbarComponent extends StatefulWidget {
  const FormsToolbarComponent({super.key});

  @override
  State<FormsToolbarComponent> createState() => _FormsToolbarComponentState();
}

class _FormsToolbarComponentState extends State<FormsToolbarComponent> with AutomaticKeepAliveClientMixin {
  List<FormDataModel> forms=[];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<FormBloc>().add(FormLoadEvent(
      forms: FormUtils.generateFormModelList(),
    ));
  }

  initiateForms(List<FormDataModel> fr){
    setState(() {
      forms = fr;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocListener<FormBloc, fs.FormState>(
      listener: (context, state) {
        if (state is fs.FormLoadedState) {

          initiateForms(state.forms);
        }
      },
      child: BlocBuilder<FormBloc, fs.FormState>(
        buildWhen: (previous, current) => current is fs.FormLoadedState,
        builder: (context, state) {
          return GridView.count(
            crossAxisCount: 3,
            children: List.generate(forms.length, (index) {
              return FormComponent(formDataModel: forms[index]);
            }),
          );
        },
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
