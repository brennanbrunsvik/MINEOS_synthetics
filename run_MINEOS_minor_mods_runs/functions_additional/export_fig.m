function export_fig(figure_handle, file_name, save_as_pdf, use_painters)
    % Simple wrapper of exportgraphics for compatibility. 
    % export_fig was used many times in the Mineos codes, which is a Github
    % project that we could use... but don't really need. 

    % Set content type based on save_as_pdf flag
    if contains(save_as_pdf, 'pdf');  
        content_type = 'vector';
    else
        content_type = 'image';
    end

    % Set renderer based on use_painters flag
    if contains(use_painters, 'painters'); 
        set(figure_handle, 'Renderer', 'painters');
    else
        set(figure_handle, 'Renderer', 'painters');
    end

    % Use exportgraphics to save the figure
    exportgraphics(figure_handle, file_name, 'ContentType', content_type);
    
end
