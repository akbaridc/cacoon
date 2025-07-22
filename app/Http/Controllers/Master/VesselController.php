<?php

namespace App\Http\Controllers\Master;

use App\Models\Vessel;
use App\Services\ApiService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;
use App\DataTables\Master\VesselDataTable;

class VesselController extends Controller
{
    public function index(VesselDataTable $dataTable)
    {
        return $dataTable->render('pages.master.vessel.index');
    }

    public function sync(Request $request)
    {
        set_time_limit(0);
        $urlEndpointVessel = "https://petroport.petrokimia-gresik.com/api/pi/v1/get-vessel-arrival";
        $secretToken = "8AhJ17M=sWnitA9oxh7ZLy?V/cAvwIP=iCSmUCsyB2iDl=rUuIIXGlBJ1EJOEpPDpR32CP/SaxSAwCoiWFZ!4eMOutj4lucIUPW99Ym-I0vWJyk2ZQ8pyMxA8qwYZdyXPlyELdYhng?=/h/W1tP8WXFNYR=7oPCZCgwVslAvZ8fsbMIzGTjWxEAuUDob7NjHk1zh7zL2HFTHZukks!bVUl9FAT8BFSiLDETdvswYdVY?n?rRj-gi2VFz6JcVG1c7";
        $apiService = new ApiService(60);
        $response = $apiService->get($urlEndpointVessel, ['secret_token' => $secretToken]);
        $datas =  $response->json();

        DB::beginTransaction();
        try {
            if($datas){
                foreach ($datas as $data) {
                    $dataUpdate = [
                        'vsl_name' => $data['vessel'],
                        'vsl_type' => $data['vessel_type'],
                        'vsl_origin_location' => $data['POL'],
                        'vsl_origin_destination' => $data['POD'],
                        'vsl_arrival_type' => $data['arrival_type'],
                        'vsl_bl_tonnage' => $data['bl_tonnage'],
                        'contract_tonnage' => $data['contract_tonnage'],
                    ];
                    $vessel = Vessel::where(['vsl_code'=> $data['code']])->first();
                    if($vessel){
                        $vessel->update($dataUpdate);
                    } else {
                        $dataUpdate = array_merge($dataUpdate, ['vsl_code' => $data['code'], 'vsl_orgn_id' => $data['id']]);
                        Vessel::create($dataUpdate);
                    }
                }
            }

            DB::commit();
            return response()->json(['status' => true,'message' => 'Vessel syncronize successfully'], 201);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['status' => false,'message' => $e->getMessage()], 400);
        }
    }
}
