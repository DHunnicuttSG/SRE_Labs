async function loadTickets() {

    const response =
        await fetch("/tickets");

    const tickets =
        await response.json();

    let html = `
    <tr>
        <th>ID</th>
        <th>Title</th>
        <th>Severity</th>
        <th>Status</th>
        <th>Owner</th>
    </tr>
    `;

    tickets.forEach(ticket => {

        html += `
        <tr>

            <td>${ticket.id}</td>

            <td>
                <a href="/ticket/${ticket.id}">
                    ${ticket.title}
                </a>
            </td>

            <td>${ticket.severity}</td>

            <td>${ticket.status}</td>

            <td>${ticket.owner}</td>

        </tr>
        `;
    });

    document
        .getElementById("ticketsTable")
        .innerHTML = html;
}

loadTickets();