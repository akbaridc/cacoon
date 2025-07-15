<?php

namespace App\DataTables;

use App\Models\Role;
use Yajra\DataTables\Html\Button;
use Yajra\DataTables\Html\Column;
use Yajra\DataTables\Services\DataTable;

class RolePermissionDataTable extends DataTable
{
    /**
     * Build DataTable class.
     *
     * @param mixed $query Results from query() method.
     * @return \Yajra\DataTables\DataTableAbstract
     */
    public function dataTable()
    {
        $query = Role::where('id', '!=', 1);
        // $query = Role::query();
        return datatables()
            ->eloquent($query)
            ->addColumn('action', function ($query) {
                $btn = '<div class="d-flex gap-2">';
                if(auth()->user()->hasPermissionTo('edit.permissions')){
                    $btn .= '<a href="javascript:void(0)" class="btn btn-warning btn-sm mx-2" @click="$(\'#modalRoles\').modal(\'show\'); $(\'#modalRoles .modal-title\').html(\'Edit Role\'); roleId=\''. $query->id .'\'; payload.role=\''. $query->name .'\'; action=\''. route('role-permission.update', $query->id) .'\'; mode=\'edit\'"><i class="fas fa-pencil-alt"></i></a>';
                }
                if(auth()->user()->hasPermissionTo('delete.permissions')){
                    $btn .= '<div x-data="deleteDatatable"><button class="btn btn-danger btn-sm delete-button" x-ref="buttonDelete" data-href="'. route('role-permission.destroy', $query->id) .'" @click="onDelete()"><i class="fas fa-trash"></i></button></div>';
                }
                $btn .= '</div>';
                return $btn;
            })
            ->addColumn('permissions', function ($query) {
                return $query->permissions_label;
            })
            ->rawColumns(['action', 'permissions'])
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
            Column::make("name")->title("Role"),
            Column::make("permissions")->title("Permissions")->orderable(false)->searchable(false),
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
        return 'RolesPermissions_' . date('YmdHis');
    }
}
