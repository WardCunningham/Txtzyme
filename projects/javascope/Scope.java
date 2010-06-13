import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import java.io.*;
import java.util.Scanner;
import java.awt.geom.*;
import java.awt.Graphics2D;
import java.util.*;

// while sleep .0805; do echo _data_200{5sp} >/dev/cu.usbmodem12341; done


public class Scope extends JApplet {
	public static String line = "";
	public static java.util.List<Integer> results = new ArrayList<Integer>(5000);

	public void init() {
		ScopePanel scopePanel = new ScopePanel();
		getContentPane().add(scopePanel, BorderLayout.CENTER);
		fork(scopePanel);
	}


	public static void main(String[] args) throws InterruptedException {
		ScopePanel scopePanel = new ScopePanel();

		JFrame f = new JFrame("Texzyme Javascope");
		f.addWindowListener(new WindowAdapter() {
			public void windowClosing(WindowEvent e) {
				System.exit(0);
			}
		});
		f.getContentPane().add(scopePanel, BorderLayout.CENTER);
		f.setSize(621+6, 356+16);
		f.setVisible(true);
		fork(scopePanel);
		System.out.println("Try this from the shell:");
		System.out.println("  while sleep .0805; do echo _data_220{5sp} >/dev/cu.usbmodem12341; done");
	}

	static void fork(ScopePanel scopePanel) {
		(new Thread(scopePanel, "Scope Refresh")).start();
		(new Thread(new TxtzymeReader(), "Results Reader")).start();
	}
}

class TxtzymeReader implements Runnable {
	public void run() {
		Scanner results = null;
		try {
			results = new Scanner(new BufferedReader(new FileReader("/dev/cu.usbmodem12341")));
			while (results.hasNext()) {
				String result = results.next();
				try {
					Scope.results.add(new Integer(result));
				}
				catch (Exception e) {
					Scope.results.clear();
					Scope.line = result;
				}
			}
		}
		catch (FileNotFoundException e) {
			System.out.println(e.getMessage());
		}
		finally {
			if (results != null) {
				results.close();
			}
		}
	}
}

class ScopePanel extends JPanel implements Runnable {
	Point from = new Point(0,0);
	Point to = new Point(0,0);

	public ScopePanel() {
		addMouseListener(new MouseAdapter() {
			public void mousePressed (MouseEvent e) {
				from = e.getPoint();
			}
			public void mouseReleased (MouseEvent e) {
				to = e.getPoint();
			}
		});
		addMouseMotionListener(new MouseMotionAdapter() {
			public void mouseDragged (MouseEvent e) {
				to = e.getPoint();
			}
		});
	 }


	public void run() {
		try {
			while (true) {
				Thread.sleep(25);
				repaint();
			}
		}
		catch (InterruptedException e) {
			System.out.println(e.getMessage());
		}
	}

	public void paintComponent(Graphics g) {
		super.paintComponent(g); //paint background

		g.setColor(Color.gray);
		g.drawString(Scope.line, 20, 15);

		g.setColor(Color.yellow);
		g.fillOval(from.x, from.y, to.x-from.x, to.y-from.y);
		g.setColor(Color.yellow.darker());
		g.drawOval(from.x, from.y, to.x-from.x, to.y-from.y);

		g.setColor(Color.black);
		g.drawLine(from.x, from.y, to.x, to.y);

		// draw GeneralPath (polyline)

		try {
			if (!Scope.results.isEmpty()) {
			Object results[] = Scope.results.toArray();
			Path2D polyline =  new Path2D.Float(GeneralPath.WIND_EVEN_ODD, results.length);

			polyline.moveTo (0, ((Integer)results[0]).intValue()/2);

			for (int index = 1; index < results.length; index++) {
			 	 polyline.lineTo(index*3, ((Integer)results[index]).intValue()/2);
			};

			Graphics2D g2 = (Graphics2D) g;
			g2.setStroke(new BasicStroke(2f, BasicStroke.CAP_ROUND, BasicStroke.JOIN_ROUND));
			g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING,RenderingHints.VALUE_ANTIALIAS_ON);
			g2.draw(polyline);
			}
		}
		catch (Exception e) {
			System.out.println(e);
			Scope.line = e.toString();
		}

	}
}