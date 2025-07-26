<?php

namespace App\DataTables;

use Spatie\Activitylog\Models\Activity;
use Yajra\DataTables\Html\Button;
use Yajra\DataTables\Html\Column;
use Yajra\DataTables\Services\DataTable;

class LogsDataTable extends DataTable
{
    /**
     * Build DataTable class.
     *
     * @param mixed $query Results from query() method.
     * @return \Yajra\DataTables\DataTableAbstract
     */
    public function dataTable()
    {
        $query = Activity::orderBy('created_at', 'desc');
        return datatables()
            ->eloquent($query)
            ->addColumn('user', function ($query) {
                return $query->causer->name ?? '-';
            })
            ->addColumn('properties', function ($query) {
                return $query->properties ? '<pre>' . json_encode($query->properties, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES) . '</pre>' : '';
            })
            ->addColumn('created_at', function ($query) {
                return \Carbon\Carbon::parse($query->created_at)->format('d M Y H:i');
            })
            ->rawColumns(['user','created_at','properties'])
            ->addIndexColumn();
    }

    /**
     * Get query source of dataTable.
     *
     * @param \App\Models\ArticleDataTable $model
     * @return \Illuminate\Database\Eloquent\Builder
     */

    /**
     * Optional method if you want to use html builder.
     *
     * @return \Yajra\DataTables\Html\Builder
     */
    public function html()
    {
        return $this->builder()
            ->addTableClass('table table-bordered dt-responsive nowrap table-striped align-middle w-100')
            ->setTableId('datatable')
            ->columns($this->getColumns())
            ->minifiedAjax()
            // ->dom('Bfrtip')
            ->orderBy(1)
            ->lengthMenu([
                [10, 25, 50, 100],
                ['10', '25', '50', '100']
            ]);
    }

    /**
     * Get columns.
     *
     * @return array
     */
    protected function getColumns()
    {
        $columns = [
            Column::make("DT_RowIndex")->title("No")->orderable(false)->searchable(false),
            Column::computed("user")->title("User"),
            Column::make("log_name")->title("Menu"),
            Column::make("description")->title("Description"),
            Column::make("properties")->title("Properties"),
            Column::make("created_at")->title("Created At"),
        ];

        return $columns;
    }

    /**
     * Get filename for export.
     *
     * @return string
     */
    protected function filename():string
    {
        return 'Logs_' . date('YmdHis');
    }
}
