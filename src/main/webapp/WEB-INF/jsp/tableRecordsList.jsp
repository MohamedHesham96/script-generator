<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!-- Table Records -->

<c:choose>
    <c:when test="${empty tablesList}">
        <div class="sg-empty" role="status">No scripts found. Try a different search or filter.</div>
    </c:when>
    <c:otherwise>
        <ul class="sg-list">
            <c:forEach items="${tablesList}" var="table">
                <c:set var="tableName" value="${fn:escapeXml(table.name)}"/>
                <li class="sg-row">
                    <input class="form-check-input" type="checkbox" value="${table.id}"
                           id="${tableName}-${table.id}">
                    <label class="sg-row-name" for="${tableName}-${table.id}" title="${tableName}">
                        <span>${tableName}</span>
                    </label>
                    <div class="sg-row-actions">
                        <button type="button" class="sg-icon-btn" title="Edit ${tableName}"
                                aria-label="Edit ${tableName}" onclick="updateTableRecord('${table.id}')">
                            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="currentColor"
                                 viewBox="0 0 16 16" aria-hidden="true" focusable="false">
                                <path d="M15.502 1.94a.5.5 0 0 1 0 .706L14.459 3.69l-2-2L13.502.646a.5.5 0 0 1 .707 0l1.293 1.293zm-1.75 2.456-2-2L4.939 9.21a.5.5 0 0 0-.121.196l-.805 2.414a.25.25 0 0 0 .316.316l2.414-.805a.5.5 0 0 0 .196-.12l6.813-6.814z"></path>
                                <path fill-rule="evenodd"
                                      d="M1 13.5A1.5 1.5 0 0 0 2.5 15h11a1.5 1.5 0 0 0 1.5-1.5v-6a.5.5 0 0 0-1 0v6a.5.5 0 0 1-.5.5h-11a.5.5 0 0 1-.5-.5v-11a.5.5 0 0 1 .5-.5H9a.5.5 0 0 0 0-1H2.5A1.5 1.5 0 0 0 1 2.5v11z"></path>
                            </svg>
                        </button>
                        <button type="button" class="sg-icon-btn sg-danger" title="Delete ${tableName}"
                                aria-label="Delete ${tableName}"
                                onclick="deleteConfirmation('${table.id}', '${tableName}')">
                            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="currentColor"
                                 viewBox="0 0 16 16" aria-hidden="true" focusable="false">
                                <path d="M5.5 5.5A.5.5 0 0 1 6 6v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm2.5 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm3 .5a.5.5 0 0 0-1 0v6a.5.5 0 0 0 1 0V6z"></path>
                                <path fill-rule="evenodd"
                                      d="M14.5 3a1 1 0 0 1-1 1H13v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V4h-.5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1H6a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1h3.5a1 1 0 0 1 1 1v1zM4.118 4 4 4.059V13a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V4.059L11.882 4H4.118zM2.5 3V2h11v1h-11z"></path>
                            </svg>
                        </button>
                    </div>
                </li>
            </c:forEach>
        </ul>
    </c:otherwise>
</c:choose>
