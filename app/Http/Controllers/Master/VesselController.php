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
        $apiService = new ApiService(60);

        DB::beginTransaction();
        try {
            $take = 100;
            $skip = 0;
            $totalFetched = 0;

            do {
                $url = "https://petroport.petrokimia-gresik.com/api/cacoon/arrivals?skip={$skip}&take={$take}&status=proses";
                $response = $apiService->get($url);
                $dataBatch = $response->json();

                if (!is_array($dataBatch) || count($dataBatch) === 0) {
                    break;
                }

                foreach ($dataBatch as $data) {
                    $dataUpdate = [
                        'vsl_name' => $data['vessel_name'] ?? null,
                        'vsl_arrival_type' => $data['arrival_type'] ?? null,
                        'vsl_survey_draught' => $data['survey_draught'] ?? null,
                        'vsl_contract_tonnage' => $data['contract_tonnage'] ?? null,
                        'vsl_cargo_name' => $data['cargo_name'] ?? null,
                        'vsl_destination' => $data['destination'] ?? null,
                        'vsl_est_time_arrival' => $data['est_time_arrival'] ?? null,
                        'vsl_time_unberthing' => $data['time_unberthing'] ?? null,
                    ];

                    $vessel = Vessel::where('vsl_code', $data['arrival_code'])->first();

                    if ($vessel) {
                        $vessel->update($dataUpdate);
                    } else {
                        $dataUpdate['vsl_code'] = $data['arrival_code'];
                        Vessel::create($dataUpdate);
                    }
                }

                $fetchedCount = count($dataBatch);
                $totalFetched += $fetchedCount;
                $skip += $take;

            } while ($fetchedCount === $take);

            logActivity('Vessel', auth()->user()->name . " syncronize data vessel");

            DB::commit();
            return response()->json(['status' => true, 'message' => "Sync complete. Total fetched: $totalFetched"], 201);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['status' => false, 'message' => $e->getMessage()], 400);
        }
    }
}
