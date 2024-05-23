function save2pdf(filename, fig, dpi)
    % Simple wrapper of exportgraphics for compatibility. 
    % save2pdf was used many times in the Mineos codes. 

    if ~ ( strcmp(filename(end-3:end), '.pdf') || strcmp(filename(end-4:end), '.jpeg') ); 
        filename = [filename '.pdf']; 
    end

    exportgraphics(fig, filename, 'ContentType', 'vector', 'Resolution', dpi); % Use exportgraphics to save the figure as a PDF

end
