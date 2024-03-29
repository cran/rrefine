#' Upload a file to OpenRefine
#'
#' This function attempts to upload contents of a file and create a new project in OpenRefine. Users can optionally navigate directly to the running instance to interact with the project. The function wraps the OpenRefine API `/command/core/create-project-from-upload` query.
#'
#' @param file Path to file to upload; upload format is inferred from the file extension, and currently only ".csv" and ".tsv" files are allowed.
#' @param project.name Optional parameter to specify name of the project to be created upon upload; default is `NULL` and project will be named 'Untitled' in OpenRefine
#' @param open.browser Boolean for whether or not the browser should open on successful upload; default is `FALSE`
#' @param ... Additional parameters to be inherited by \code{\link{refine_path}}; allows users to specify `host` and `port` arguments if the OpenRefine instance is running at a location other than `http://127.0.0.1:3333`
#' @return Operates as a side-effect, either opening a browser and pointing to the OpenRefine instance (if `open.browser=TRUE`) or issuing a message.
#' @references \url{https://docs.openrefine.org/technical-reference/openrefine-api#create-project}
#' @export
#' @md
#' @examples
#' \dontrun{
#' fp <- system.file("extdata", "lateformeeting.csv", package = "rrefine")
#' refine_upload(fp, project.name = "lfm")
#' write.table(x = mtcars, file = "mtcars.tsv", sep = "\t")
#' refine_upload(file = "mtcars.tsv", project.name = "mtcars")
#' }
#'

refine_upload <- function(file, project.name = NULL , open.browser = FALSE, ...) {

    ## check that OpenRefine is running
    refine_check(...)

    ## check that file exits before trying to proceed
    if(!file.exists(file)) {
        stop("Path to upload file could not be resolved. Check that the file exists.")
    }

    ## define upload query
    query <- refine_query("create-project-from-upload", use_token = TRUE, ...)

    ## get list of project ids for the refine instance pre upload
    pre_upload <- names(refine_metadata(...)$projects)

    ## get format from the file extension
    ## format will be used in POST request below
    ## this logic includes a check to stop() if the inferred format is not one of the allowed values
    format <- tools::file_ext(file)
    if(format %in% c("csv", "tsv")) {
        format <- paste0("text/line-based/", format)
    } else {
        stop(sprintf("Upload file extension is %s. Format must be 'csv' or 'tsv'", format))
    }

    ## try to post project to refine
    httr::POST(query,
               body = list(
        "project-file" = httr::upload_file(file),
        "project-name" = project.name,
        "format" = format
        )
    )

    ## get list of project ids after upload
    post_upload <- names(refine_metadata(...)$projects)

    ## we don't know what the new project id will be ...
    ## so to check successful upload we use logic that if there are *more* ids post upload ...
    ## then the upload was successful
    if(length(post_upload) > length(pre_upload)) {

        new_id <- setdiff(post_upload, pre_upload)
        new_url <- paste0(refine_path(...), "/project?project=", new_id)
        ## open browser
        if (open.browser) {
            utils::browseURL(new_url)
        } else {
            message(sprintf("Upload successful. Visit %s to view the project in OpenRefine.", new_url))
        }
        ## if not and if the ids are the same pre/post upload ...
        ## then assume upload was unsuccessful
    } else if (all(post_upload == pre_upload)) {
        stop("Upload was unsuccessful. Check the contents of the file and/or try uploading through the web interface to debug.")
    }

}
