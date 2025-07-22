<?php

namespace App\DataTables\Master;

use App\Models\Palka;
use Yajra\DataTables\Html\Button;
use Yajra\DataTables\Html\Column;
use Yajra\DataTables\Services\DataTable;

class PalkasDataTable extends DataTable
{
    /**
     * Build DataTable class.
     *
     * @param mixed $query Results from query() method.
     * @return \Yajra\DataTables\DataTableAbstract
     */
    public function dataTable()
    {
        $query = Palka::query();
        return datatables()
            ->eloquent($query)
            ->addColumn('action', function ($query) {
                $btn = '<div class="d-flex gap-2">';
                if(auth()->user()->hasPermissionTo('edit.palka')){
                    $btn .= '<a href="javascript:void(0)" @click="showModal = true; modalTitle = \'Edit Palka\'; palkaId=\''. $query->pk_id .'\'; payload.palka.value=\''. $query->pk_name .'\'; action=\''. route('palka.update', $query->pk_id) .'\'; mode=\'edit\'" class="btn btn-warning btn-sm" ><i class="fas fa-pencil-alt"></i></a>';
                }
                if(auth()->user()->hasPermissionTo('delete.palka')){
                    $btn .= '<div x-data="deleteDatatable"><button class="btn btn-danger btn-sm delete-button" x-ref="buttonDelete" data-href="'. route('palka.destroy', $query->pk_id) .'" @click="onDelete()"><i class="fas fa-trash"></i></button></div>';
                }
                $btn .= '</div>';
                return $btn;
            })
            ->addColumn('pk_is_active', function ($query) {
                return $query->pk_is_active ? '<span class="badge rounded-pill bg-primary">Active</span>' : '<span class="badge rounded-pill bg-danger">Inactive</span>';
            })
            ->rawColumns(['action', 'pk_is_active'])
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
        return [
            Column::make("DT_RowIndex")->title("No")->orderable(false)->searchable(false),
            Column::make("pk_name")->title("Name"),
            Column::make("pk_is_active")->title("Status")->searchable(false)->orderable(false),
            Column::computed('action')->title('Action')->orderable(false)->searchable(false),
        ];
    }

    /**
     * Get filename for export.
     *
     * @return string
     */
    protected function filename():string
    {
        return 'Palkas_' . date('YmdHis');
    }
}
