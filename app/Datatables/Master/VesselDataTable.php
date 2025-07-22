<?php

namespace App\DataTables\Master;

use App\Models\Vessel;
use Yajra\DataTables\Html\Button;
use Yajra\DataTables\Html\Column;
use Yajra\DataTables\Services\DataTable;

class VesselDataTable extends DataTable
{
    /**
     * Build DataTable class.
     *
     * @param mixed $query Results from query() method.
     * @return \Yajra\DataTables\DataTableAbstract
     */
    public function dataTable()
    {
        $query = Vessel::query();
        return datatables()
            ->eloquent($query)
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
            ->setTableId('datatable-vessel')
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
        return [
            Column::make("DT_RowIndex")->title("No")->orderable(false)->searchable(false),
            Column::make("vsl_code")->title("Code"),
            Column::make("vsl_name")->title("Name"),
            Column::make("vsl_type")->title("Type"),
            Column::make("vsl_origin_location")->title("Origin Location"),
            Column::make("vsl_origin_destination")->title("Origin Destination"),
            Column::make("vsl_arrival_type")->title("Arrival Type"),
            Column::make("vsl_bl_tonnage")->title("Tonnage"),
            Column::make("vsl_contract_tonnage")->title("Contract Tonnage"),
        ];
    }

    /**
     * Get filename for export.
     *
     * @return string
     */
    protected function filename():string
    {
        return 'Vessel_' . date('YmdHis');
    }
}
