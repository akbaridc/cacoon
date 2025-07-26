<?php

namespace App\DataTables\Master;

use App\Models\User;
use Yajra\DataTables\Html\Button;
use Yajra\DataTables\Html\Column;
use Yajra\DataTables\Services\DataTable;

class UsersDataTable extends DataTable
{
    /**
     * Build DataTable class.
     *
     * @param mixed $query Results from query() method.
     * @return \Yajra\DataTables\DataTableAbstract
     */
    public function dataTable()
    {
        $query = User::query();
        return datatables()
            ->eloquent($query)
            ->addColumn('action', function ($query) {
                $btn = '<div class="d-flex gap-2">';
                if(auth()->user()->hasPermissionTo('edit.users')){
                    $btn .= '<a href="' . route('users.edit', $query->id) . '" class="btn btn-warning btn-sm" ><i class="fas fa-pencil-alt"></i></a>';
                }
                if(auth()->user()->hasPermissionTo('view.users')){
                    $btn .= '<a href="' . route('users.show', $query->id) . '" class="btn btn-success btn-sm"><i class="fas fa-eye"></i></a>';
                }
                if(auth()->user()->hasPermissionTo('delete.users') && $query->id != auth()->user()->id){
                    $btn .= '<div x-data="deleteDatatable"><button class="btn btn-danger btn-sm delete-button" x-ref="buttonDelete" data-href="'. route('users.destroy', $query->id) .'" @click="onDelete()"><i class="fas fa-trash"></i></button></div>';
                }
                $btn .= '</div>';
                return $btn;
            })
            ->addColumn('is_active', function ($query) {
                return $query->is_active ? '<span class="badge rounded-pill bg-primary">Active</span>' : '<span class="badge rounded-pill bg-danger">Inactive</span>';
            })
            ->addColumn('access_mobile', function ($query) {
                return $query->access_mobile ? '<span class="badge rounded-pill bg-primary">Active</span>' : '<span class="badge rounded-pill bg-danger">Inactive</span>';
            })
            ->addColumn('role', function ($query) {
                return $query->role_string;
            })
            ->addColumn('avatar', function ($query) {
                return $query->getFirstMediaUrl('avatars', 'thumb') ? '<img src="' . $query->getFirstMediaUrl('avatars', 'thumb') . '" class="thumb-lg rounded-circle ">' : '<img src="' . asset('images/default-image.png') . '" class="thumb-lg rounded-circle">';
            })
            ->rawColumns(['action', 'is_active', 'role', 'avatar', 'access_mobile'])
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
            Column::make("avatar")->title("Picture"),
            Column::make("nik")->title("NIK"),
            Column::make("name")->title("Name"),
            Column::make("email")->title("Email"),
            Column::computed("role")->title("Role"),
            Column::make("is_active")->title("Status")->searchable(false)->orderable(false),
            Column::make("access_mobile")->title("Access Mobile")->searchable(false)->orderable(false),
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
        return 'Users_' . date('YmdHis');
    }
}
