package com.ss.paging.helper;

import javax.servlet.http.HttpServletRequest;

import org.displaytag.properties.SortOrderEnum;


public class PaginateListFactory {

    public ExtendedPaginatedList getPaginatedListFromRequest(
            HttpServletRequest request) {

        ExtendedPaginatedList paginatedList = new PaginatedListImpl();
        String sortCriterion = null;
        String thePage = null;
        if (request != null) {
            sortCriterion = request
                    .getParameter(ExtendedPaginatedList.IRequestParameters.SORT);
            paginatedList
                    .setSortDirection(ExtendedPaginatedList.IRequestParameters.DESC
                            .equals(request
                                    .getParameter(ExtendedPaginatedList.IRequestParameters.DIRECTION)) ? SortOrderEnum.DESCENDING
                            : SortOrderEnum.ASCENDING);
            thePage = request
                    .getParameter(ExtendedPaginatedList.IRequestParameters.PAGE);
        }
        paginatedList.setSortCriterion(sortCriterion);
        int pageSize = 10; // Rows per page
        paginatedList.setPageSize(pageSize);
        if (thePage != null) {
            int index = paginatedList == null ? 0
                    : Integer.parseInt(thePage) - 1;
            paginatedList.setIndex(index);
        } else {
            paginatedList.setIndex(0);
        }

        return paginatedList;
    }
}
