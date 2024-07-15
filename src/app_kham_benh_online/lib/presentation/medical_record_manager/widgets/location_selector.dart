import 'package:flutter/material.dart';
import 'package:koruko_app/service/api_service.dart';


class LocationSelector extends StatefulWidget {
  const LocationSelector({super.key});

  @override
  LocationSelectorState createState() => LocationSelectorState();
}

class LocationSelectorState extends State<LocationSelector> {
  final ApiService apiService = ApiService();
  List<dynamic> provinces = [];
  List<dynamic> districts = [];
  List<dynamic> wards = [];
  late String selectedProvinceId;
  late String selectedDistrictId;

  @override
  void initState() {
    super.initState();
    _loadProvinces();
  }

  void _loadProvinces() async {
    var fetchedProvinces = await apiService.fetchProvinces();
    setState(() {
      provinces = fetchedProvinces;
    });
  }

  void _loadDistricts(String provinceId) async {
    var fetchedDistricts =
        await apiService.fetchDistrictsByProvince(provinceId);
    setState(() {
      districts = fetchedDistricts;
      wards = []; // Clear wards when province changes
    });
  }

  void _loadWards(String districtId) async {
    var fetchedWards = await apiService.fetchWardsByDistrict(districtId);
    setState(() {
      wards = fetchedWards;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton<String>(
          value: selectedProvinceId,
          hint: const Text('Select Province'),
          items: provinces.map<DropdownMenuItem<String>>((province) {
            return DropdownMenuItem<String>(
              value: province['id'],
              child: Text(province['name']),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              selectedProvinceId = newValue!;
              selectedDistrictId = ''; // Reset selected district
            });
            _loadDistricts(newValue!);
          },
        ),
        if (districts.isNotEmpty)
          DropdownButton<String>(
            value: selectedDistrictId,
            hint: const Text('Select District'),
            items: districts.map<DropdownMenuItem<String>>((district) {
              return DropdownMenuItem<String>(
                value: district['id'],
                child: Text(district['name']),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                selectedDistrictId = newValue!;
              });
              _loadWards(newValue!);
            },
          ),
        if (wards.isNotEmpty)
          DropdownButton<String>(
            hint: const Text('Select Ward'),
            items: wards.map<DropdownMenuItem<String>>((ward) {
              return DropdownMenuItem<String>(
                value: ward['id'],
                child: Text(ward['name']),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                // Update ward selection state here, if needed
              });
            },
          ),
      ],
    );
  }
}
