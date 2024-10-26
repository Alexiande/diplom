import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class UploadStepScreen extends StatefulWidget {
  @override
  _UploadStepScreenState createState() => _UploadStepScreenState();
}

class _UploadStepScreenState extends State<UploadStepScreen> {
  final ImagePicker _picker = ImagePicker();
  double _sliderValue = 30;

  Future<void> _requestGalleryPermission(BuildContext context) async {
    var status = await Permission.storage.status;

    if (status.isGranted) {
      final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
      if (photo != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Фото выбрано: ${photo.path}')),
        );
      }
    } else if (status.isDenied) {
      status = await Permission.storage.request();
      if (status.isGranted) {
        _requestGalleryPermission(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Доступ к галерее запрещен')),
        );
      }
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => _requestGalleryPermission(context),
              child: Container(
                width: double.infinity,
                height: 170,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.photo_rounded, size: 50, color: Colors.grey),
                      SizedBox(height: 8),
                      Text(
                        'Add Cover Photo',
                        style: TextStyle(
                          fontSize: 17.0,
                          color: Color(0xFF2E3E5C),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '(up to 12 Mb)',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Food Name',
              style: TextStyle(
                fontSize: 17.0,
                color: Color(0xFF2E3E5C),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFD0DBEA), width: 1),
                borderRadius: BorderRadius.circular(32.0),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Enter food name',
                  filled: true,
                  fillColor: Colors.white,
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 17.0,
                color: Color(0xFF2E3E5C),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFD0DBEA), width: 1),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Tell a little about your food',
                  filled: true,
                  fillColor: Colors.white,
                  border: InputBorder.none,
                ),
                maxLines: 3,
              ),
            ),
            const SizedBox(height: 24),
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Cooking Duration ',
                    style: TextStyle(
                      fontSize: 17.0,
                      color: Color(0xFF2E3E5C),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '(in minutes)',
                    style: TextStyle(
                      color: Color(0xFF9FA5C0),
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('<10', style: TextStyle(color: Color(0xFF5E6ED8), fontSize: 15, fontWeight: FontWeight.bold)),
                    Text('30', style: TextStyle(color: Color(0xFF5E6ED8), fontSize: 15, fontWeight: FontWeight.bold)),
                    Text('>60', style: TextStyle(color: Color(0xFF5E6ED8), fontSize: 15, fontWeight: FontWeight.bold)),
                  ],
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: const Color(0xFF5E6ED8),
                    inactiveTrackColor: const Color(0xFFD0DBEA),
                    thumbColor: const Color(0xFF5E6ED8),
                    trackHeight: 8.0,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
                  ),
                  child: Slider(
                    value: _sliderValue,
                    min: 10,
                    max: 60,
                    divisions: 5,
                    label: _sliderValue.round().toString(),
                    onChanged: (value) {
                      setState(() {
                        _sliderValue = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Действие для следующего шага
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5E6ED8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                  minimumSize: const Size(double.infinity, 70),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}
