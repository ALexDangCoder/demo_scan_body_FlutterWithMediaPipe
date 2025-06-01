import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/data.dart';
import '../../../services/model_inference_service.dart';
import '../../../services/service_locator.dart';
import '../../camera/camera_page.dart';

class ModelCard extends StatelessWidget {
  const ModelCard({
    required this.index,
    required this.scale,
    Key? key,
  }) : super(key: key);

  final int index;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _onTapCamera(context),
      child: _ModelDescription(index: index),
    );
  }

  void _onTapCamera(BuildContext context) {
    locator<ModelInferenceService>().setModelConfig(index);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return CameraPage(index: index);
        },
      ),
    );
  }
}

class _ModelDescription extends StatelessWidget {
  const _ModelDescription({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: const BorderRadius.all(Radius.circular(16)),
          ),
          padding: EdgeInsets.all(ScreenUtil().setWidth(16.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                models[index]['title']!,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: ScreenUtil().setSp(20.0),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(8.0),
              ),
              Text(
                models[index]['text']!,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: ScreenUtil().setSp(12.0),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
