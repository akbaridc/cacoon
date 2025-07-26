<?php

namespace App\Http\Controllers;

use App\DataTables\LogsDataTable;

class LogsController extends Controller
{
    public function index(LogsDataTable $dataTable)
    {
        return $dataTable->render('pages.logs.index');
    }
}
