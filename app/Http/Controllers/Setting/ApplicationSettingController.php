<?php

namespace App\Http\Controllers\Setting;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;
use App\Models\SettingApplication;

class ApplicationSettingController extends Controller
{
    public function index()
    {
        $settingApplication = SettingApplication::first();

        $initialPayload = [
            'id' => $settingApplication->id ?? null,
            'application_name' => $settingApplication->application_name ?? env('APP_NAME', '-'),
            'email_send_provider' => $settingApplication->email_send_provider ?? env('MAIL_USERNAME', '-'),
            'email_send_password_provider' => $settingApplication->email_send_password_provider ?? env('MAIL_PASSWORD', '-'),
            'email_receive_authentication' => $settingApplication->email_receive_authentication ?? '-',
        ];

        return view('pages.settings.setting-application.index', compact('settingApplication', 'initialPayload'));
    }

    public function update(Request $request)
    {
        DB::beginTransaction();
        try {
            $data = [
                'application_name' => $request->application_name == '-' ? null : $request->application_name,
                'email_send_provider' => $request->email_send_provider == '-' ? null : $request->email_send_provider,
                'email_send_password_provider' => $request->email_send_password_provider == '-' ? null : $request->email_send_password_provider,
                'email_receive_authentication' => $request->email_receive_authentication == '-' ? null : $request->email_receive_authentication,
            ];

            if($request->id){
                SettingApplication::where('id', $request->id)->update($data);
            } else {
                SettingApplication::create($data);
            }

            $settingApplication = SettingApplication::first();

            DB::commit();
            return response()->json(['status' => true,'message' => 'Setting application updated successfully', 'data' => $settingApplication]);
        } catch (\Throwable $th) {
            DB::rollBack();
            return response()->json(['status' => false,'message' => $th->getMessage()]);
        }
    }
}
